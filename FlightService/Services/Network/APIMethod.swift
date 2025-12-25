//
//  HTTPMethod.swift
//  FlightService
//
//  Created by Сергей on 28.11.2025.
//

import Foundation

enum ApiMethod: EndpointProtocol {
  
  case fetchFlight(origin: String, destination: String, departDate: String, returnDate: String?)
  case fetchFotoCity(cityCode: String)
  case fetchPopularDirections(origin: String, currency: String)
  
  var httpMethod: HTTPMethod {
    switch self {
    case .fetchFlight:
      return .get
    case .fetchFotoCity:
      return .get
    case .fetchPopularDirections:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .fetchFlight:
      return "/v1/prices/cheap"
    case .fetchFotoCity(let cityCode):
      return "/static/cities/960x720/\(cityCode).jpg"
    case .fetchPopularDirections:
      return "/v1/city-directions"
    }
  }
  
  var queryItems: [String : Any] {
    switch self {
      case let .fetchFlight(origin, destination, departDate, returnDate):
      var params = [
        "origin": origin.uppercased(),
        "destination": destination.uppercased(),
        "depart_date": departDate,
      ]
      
      if let returnDate = returnDate {
        params["return_date"] = returnDate
      }
      
      return params
      
    case let .fetchFotoCity(cityCode):
      return ["cityCode" : cityCode]
      
    case let .fetchPopularDirections(origin, currency):
      return ["origin": origin.uppercased(), "currency": currency]
    }
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case put = "PUT"
  case post = "POST"
  case delete = "DELETE"
}
