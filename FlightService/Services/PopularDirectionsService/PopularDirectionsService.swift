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
}

//origin  -  The point of departure.
//destination  -  The point of destination.
//departure_at  -  The date of departure.
//return_at  -  The date of return.
//expires_at  -  Date on which the found price expires (UTC+0).
//number_of_changes  -  The number of transfers.
//price  -  The cost of a flight, in the currency specified.
//found_at  -  The time and the date, for which a ticket was found.
//transfers  -  The number of directs.
//airline  -  IATA of an airline.
//flight_number  -  Flight number.
//currency  -  Currency of response.

//GET https://api.travelpayouts.com/v1/city-directions?origin=MOW&currency=usd&token=PutHereYourToken
//{
//"success":true,
//"data":{
//    "AER":{
//        "origin":"MOW",
//        "destination":"AER",
//        "price":3673,
//        "transfers":0,
//        "airline":"WZ",
//        "flight_number":125,
//        "departure_at":"2016-03-08T16:35:00Z",
//        "return_at":"2016-03-17T16:05:00Z",
//        "expires_at":"2016-02-22T09:32:44Z"
//    }
//},
//"error":null,
//"currency":"rub"
//}
