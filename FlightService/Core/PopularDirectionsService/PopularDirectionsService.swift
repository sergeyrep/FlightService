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
