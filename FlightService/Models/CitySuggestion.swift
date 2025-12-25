//
//  SearchModel.swift
//  FlightService
//
//  Created by Сергей on 01.12.2025.
//

import Foundation

struct CitySuggestion: Codable, Hashable {
    let name: String
    let code: String // IATA код
    let countryName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case countryName = "country_name"
    }
}
