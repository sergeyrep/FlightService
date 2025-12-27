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
  case badResponseFoto
  case urlSessionFotoFaild
}

protocol NetworkServiceProtocol {
  func fetchData<T: Decodable>(_ endpoint: EndpointProtocol, baseURL: String) async throws -> T
  func fetchFoto(_ endpoint: EndpointProtocol, baseURL: String) async throws -> Data
  func parseJSONPResponse<T: Decodable>(_ data: Data) throws -> T
}

final class NetworkService: NetworkServiceProtocol {
  
  private let apiKey: String
  
  init(apiKey: String = "37442fdbe554e59b50d7db0d8a59905b") {
    self.apiKey = apiKey
  }
  
  func fetchFoto(_ endpoint: EndpointProtocol, baseURL: String) async throws -> Data {
    
    let request = try buildRequest(endpoint: endpoint, baseUrl: baseURL)
    
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
        throw NetworkServiceError.badResponseFoto
      }
      
      return data
      
    } catch {
      throw NetworkServiceError.urlSessionFotoFaild
    }
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
      
      // Для fetchLocation нужна специальная обработка JSONP
      if endpoint.path.contains("whereami") {
        return try parseJSONPResponse(data) as T
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

extension NetworkService {
  func parseJSONPResponse<T: Decodable>(_ data: Data) throws -> T {
    guard let responseString = String(data: data, encoding: .utf8) else {
      throw NetworkServiceError.decodingError
    }
    
    print("📥 Raw response: \(responseString.prefix(200))...")
    
    // Проверяем формат JSONP: useriata({...})
    guard responseString.hasPrefix("useriata("),
          responseString.hasSuffix(")") else {
      throw NetworkServiceError.decodingError
    }
    
    // Извлекаем JSON из JSONP
    let jsonStartIndex = responseString.index(responseString.startIndex, offsetBy: 9) // "useriata(".count
    let jsonEndIndex = responseString.index(responseString.endIndex, offsetBy: -1)
    let jsonString = String(responseString[jsonStartIndex..<jsonEndIndex])
    
    print("📦 JSON extracted: \(jsonString)")
    
    // Декодируем
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: Data(jsonString.utf8))
  }
}
