//
//  FlightService.swift
//  FlightService
//
//  Created by Сергей on 30.11.2025.
//

import Foundation

protocol FlightServiceProtocol {
  func sendRequestForFlight(
    origin: String,
    destination: String,
    departDate: Date,
    returnDate: Date?
  ) async throws -> [Flight]
}

final class FlightService: FlightServiceProtocol {
  
  private let baseURL = "https://api.travelpayouts.com"
  private let networkService: NetworkServiceProtocol
  
  init(networkService: NetworkServiceProtocol = NetworkService()) {
    self.networkService = networkService
  }
  
  func sendRequestForFlight(
    origin: String,
    destination: String,
    departDate: Date,
    returnDate: Date?
  ) async throws -> [Flight] {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let departDateString = dateFormatter.string(from: departDate)
    let returnDateString = returnDate.map { dateFormatter.string(from: $0) }
    
    let endpoint: EndpointProtocol = ApiMethod.fetchFlight(
      origin: origin,
      destination: destination,
      departDate: departDateString,
      returnDate: returnDateString
    )
    
    do {
      let response: FlightResponse = try await networkService.fetchData(endpoint, baseURL: baseURL)
      let flights = response.convertToFlights(origin: origin)
      return flights
    } catch {
      print("bad response flight")
      throw error
    }
  }
}

// MARK: - Error Types
enum FlightError: Error, LocalizedError {
  case invalidOrigin
  case invalidDestination
  case networkError(Error)
  case locationNotFound
  
  var errorDescription: String? {
    switch self {
    case .invalidOrigin:
      return "Укажите город отправления"
    case .invalidDestination:
      return "Укажите город назначения"
    case .networkError(let error):
      return "Ошибка сети: \(error.localizedDescription)"
    case .locationNotFound:
      return "Не удалось определить ваше местоположение"
    }
  }
}
