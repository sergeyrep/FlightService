//
//  PopularDirectionsService.swift
//  FlightService
//
//  Created by Сергей on 24.12.2025.
//

import Foundation

protocol PopularDirectionsServiceProtocol {
  func sendPopularDirections(origin: String, currency: String) async throws -> [PopularDirectionsModel]
}

final class PopularDirectionsService: PopularDirectionsServiceProtocol {
  
  let networkService: NetworkServiceProtocol
  let baseURL = "https://api.travelpayouts.com"
  
  init(networkService: NetworkServiceProtocol = NetworkService()) {
    self.networkService = networkService
  }
  
  func sendPopularDirections(origin: String, currency: String) async throws -> [PopularDirectionsModel] {
    
    let endpoint: EndpointProtocol = ApiMethod.fetchPopularDirections(origin: origin, currency: currency)
    
    do {
      let response: PopularDirectionsResponse = try await networkService.fetchData(endpoint, baseURL: baseURL)
      let directions = response.convertToPopularDirectionsModel()
      return directions
    } catch {
      print("bad response popular directions")
      throw error
    }
  }
}
