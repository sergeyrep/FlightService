//
//  File.swift
//  FlightService
//
//  Created by Сергей on 26.12.2025.
//

import Foundation

protocol DefenitionLocationServiceProtocol {
  func sendLocation() async throws -> UserIata
}

final class DefenitionLocationService: DefenitionLocationServiceProtocol {
  
  private var networkService: NetworkServiceProtocol
  private let baseURL: String = "https://www.travelpayouts.com"
  
  init(networkService: NetworkServiceProtocol = NetworkService()) {
    self.networkService = networkService
  }
  
  func sendLocation() async throws -> UserIata {
    
    let endpoint: EndpointProtocol = ApiMethod.fetchLocation
    
    do {
      let response: UserIata = try await networkService.fetchData(endpoint, baseURL: baseURL)
      //let result = response.convertUserIata()
      return response
    } catch {
      print("invalid response service")
      throw error
    }
  }
}

//GET https://www.travelpayouts.com/whereami?locale=ru&callback=useriata&ip=62.105.128.0
