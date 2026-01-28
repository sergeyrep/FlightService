//
//  PopularModel.swift
//  FlightService
//
//  Created by Сергей on 21.01.2026.
//

import Foundation

struct PopularDirectionsResponse: Codable {
  let success: Bool
  let data: [String: PopularDirectionsData]
  let error: String?
  let currency: String
  
  func convertToPopularDirectionsModel() -> [PopularDirectionsModel] {
    
    var result: [PopularDirectionsModel] = []
    
    for (_, value) in data {
      let model = PopularDirectionsModel(origin: value.origin, destination: value.destination, price: value.price)
      result.append(model)
    }
    
    return result
  }
}

struct PopularDirectionsData: Codable, Identifiable {
  let id = UUID()
  let origin: String
  let destination: String
  let price: Int
  let transfers: Int
  let airline: String
  let flightNumber: Int
  let departureAt: String
  let returnAt: String
  let expiresAt: String
  
  enum CodingKeys: String, CodingKey {
    case origin, destination, price, transfers, airline
    case flightNumber = "flight_number"
    case departureAt = "departure_at"
    case returnAt = "return_at"
    case expiresAt = "expires_at"
  }
}

struct PopularDirectionsModel: Identifiable {
  let id = UUID()
  let origin: String
  let destination: String
  let price: Int
  
  static let directions: [PopularDirectionsModel] = [
    PopularDirectionsModel(origin: "Москва", destination: "Париж", price: 10000),
    PopularDirectionsModel(origin: "Красноярск", destination: "Москва", price: 12000),
    PopularDirectionsModel(origin: "Абакан", destination: "Кызыл", price: 15000),
    PopularDirectionsModel(origin: "Новосибирск", destination: "Санкт-Петербург", price: 19000)
    ]
}
