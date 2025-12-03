//
//  SearchIATAService.swift
//  FlightService
//
//  Created by Сергей on 01.12.2025.
//

import Foundation

protocol SearchIATAServiceProtocol {
  func searchCity(query: String) async throws -> [CitySuggestion]
}

class SearchIATAService: SearchIATAServiceProtocol {
  
  private let baseURL = "https://autocomplete.travelpayouts.com"
  
  func searchCity(query: String) async throws -> [CitySuggestion] {
    
    guard let url = URL(string: "\(baseURL)/places2?locale=ru&types[]=airport&types[]=city&term=\(query)") else {
      throw URLError(.badURL)
    }
    
    print(url)
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoder = JSONDecoder()
    let result = try decoder.decode([CitySuggestion].self, from: data)
    
    return result
  }
}
//places2?locale=ru&types[]=airport&types[]=city&term=\(query)
