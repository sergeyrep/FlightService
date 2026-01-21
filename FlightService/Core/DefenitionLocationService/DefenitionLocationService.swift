//
//  File.swift
//  FlightService
//
//  Created by Сергей on 26.12.2025.
//

import Foundation

protocol DefenitionLocationServiceProtocol {
  
 //тут добавим переменную
  var currentLocation: UserIata? { get }
  
  func sendLocation() async throws -> UserIata
}

final class DefenitionLocationService: DefenitionLocationServiceProtocol {
  
  static let shared: DefenitionLocationServiceProtocol = DefenitionLocationService()
  
  private var networkService: NetworkServiceProtocol
  private let baseURL: String = "https://www.travelpayouts.com"
  
  var currentLocation: UserIata?
  
  private init(
    networkService: NetworkServiceProtocol = NetworkService()
  ) {
    self.networkService = networkService
  }
  
  func sendLocation() async throws -> UserIata {
    
    let endpoint: EndpointProtocol = ApiMethod.fetchLocation
    
    do {
      let response: UserIata = try await networkService.fetchData(endpoint, baseURL: baseURL)
      //let result = response.convertUserIata()
      currentLocation = response
      return response
    } catch {
      print("invalid response service")
      currentLocation = UserIata(
        iata: "MOW",
        name: "Москва",
        countryName: "RU",
        coordinates: nil
      )
      throw error
    }
  }
}

//GET https://www.travelpayouts.com/whereami?locale=ru&callback=useriata&ip=62.105.128.0
