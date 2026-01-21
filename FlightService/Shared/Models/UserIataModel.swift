//
//  UserIata.swift
//  FlightService
//
//  Created by Сергей on 26.12.2025.
//

import Foundation

struct UserIataResponse: Codable {
  let useriata: [String: UserIata]
  
  func convertUserIata() -> [UserIata] {
    
    var result: [UserIata] = []
    
    for (_, value) in useriata {
      result.append(value)
    }
    
    return result
  }
}

struct UserIata: Codable {
  let iata: String
  let name: String?
  let countryName: String?
  let coordinates: String?
  
  enum CodingKeys: String, CodingKey {
    case iata, name
    case countryName = "country_name"
    case coordinates
  }
}
