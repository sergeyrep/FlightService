//
//  NetworkService.swift
//  FlightService
//
//  Created by Сергей on 27.11.2025.
//

import Foundation

enum NetworkServiceError: Error {
  case decodingError
  case badURL
  case badResponse
}

protocol NetworkServiceProtocol {
  func fetchData<T: Decodable>(_ endpoint: EndpointProtocol, baseURL: String) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
  
  private let apiKey: String
  
  init(apiKey: String = "37442fdbe554e59b50d7db0d8a59905b") {
    self.apiKey = apiKey
  }
  
  func fetchData<T: Decodable>(_ endpoint: EndpointProtocol, baseURL: String) async throws -> T {
    
    let request = try buildRequest(endpoint: endpoint, baseUrl: baseURL)
    
    print("🚀 \(request)")
    
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
        throw NetworkServiceError.badResponse
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
      } catch {
        throw error
      }
    } catch {
      throw error
    }
  }
  
  private func buildRequest(endpoint: EndpointProtocol, baseUrl: String) throws -> URLRequest {
    guard let baseUrl = URL(string: baseUrl) else {
      throw NetworkServiceError.badURL
    }
    
    var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
    urlComponents?.path = endpoint.path
    
    var queryParams = endpoint.queryItems
    queryParams["token"] = apiKey
    
    urlComponents?.queryItems = queryParams.map { key, value in
      URLQueryItem(name: key, value: "\(value)")
    }
    
    guard let url = urlComponents?.url else {
      throw NetworkServiceError.badURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.httpMethod.rawValue
    
    return request
  }
}

//  func buildQueryItems(endpoint: EndpointProtocol) -> String? {
//    var params: [String: Any] = endpoint.queryItems
//    params["token"] = apiKey
//    var components = URLComponents()
//    components.queryItems = params.map { key, value in
//      URLQueryItem(name: key, value: "\(value)")
//    }
//    return components.percentEncodedQuery
//  }


//struct URLEncoder {
//  func encode(params: [String: Any]) -> String? {
//    var components = URLComponents()
//    components.queryItems = params.map { key, value in
//      URLQueryItem(name: key, value: "\(value)")
//    }
//    return components.percentEncodedQuery
//  }
//}
