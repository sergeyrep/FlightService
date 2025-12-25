//
//  PopularViewModel.swift
//  FlightService
//
//  Created by Сергей on 22.12.2025.
//

import Foundation
import Combine
import UIKit

final class PopularViewModel: ObservableObject {
  
  //@Published var foto: UIImage?
  @Published var popularDirections: [PopularDirectionsModel] = []
  
  //пробую реализовать автозамену кода иата на название города
  @Published var popularDirectionsNameCity: [CitySuggestion] = []
  @Published var cityNames: [String: String] = [:]
  private var cancellables = Set<AnyCancellable>()
  
  let networkServiceSearchCityIata: SearchIATAServiceProtocol
  
  let networkServiceFoto: CityFotoServiceProtocol
  let networkServiceCurency: PopularDirectionsServiceProtocol
  
  init(
    networkServiceFoto: CityFotoServiceProtocol = CityFotoServices(),
    networkServiceCurency: PopularDirectionsServiceProtocol = PopularDirectionsService(),
    networkServiceSearchCityIata: SearchIATAServiceProtocol = SearchIATAService()
  ) {
    self.networkServiceFoto = networkServiceFoto
    self.networkServiceCurency = networkServiceCurency
    self.networkServiceSearchCityIata = networkServiceSearchCityIata
    
    Task {
      await loadPopularDirections()
    }
  }
  
  @MainActor
  func loadPopularDirections() async {
    do {
      let response = try await networkServiceCurency.sendPopularDirections(
        origin: "MOW",
        currency: "rub"
      )
      self.popularDirections = response
      
      await loadCityNames(for: response)
      
    } catch {
      print("❌ Error: \(error)")
    }
  }
  
//  func loadCityFoto(for cityCode: String) async {
//    
//    async let fotoTask = getFoto(cityCode: cityCode)
//    
//    do {
//      let foto = try await fotoTask
//      self.foto = foto
//    } catch {
//      print("no load foto")
//    }
//  }
//  
//  func getFoto(cityCode: String) async throws -> UIImage {
//    try await networkServiceFoto.sendRequestForCityFoto(cityCode: cityCode)
//  }
  
  func loadFoto(cityCode: String) -> String {
    "https://photo.hotellook.com/static/cities/960x720/\(cityCode).jpg"
  }
}


extension PopularViewModel {
  
  @MainActor
  private func loadCityNames(for directions: [PopularDirectionsModel]) async {
    for direction in directions {
      await loadCityName(for: direction.destination)
    }
  }
  
  @MainActor
  private func loadCityName(for cityCode: String) async {
    // Если уже загружено - пропускаем
    if cityNames[cityCode] != nil { return }
    
    do {
      let result = try await networkServiceSearchCityIata.searchCity(query: cityCode)
      
      // Берем первый результат (наиболее релевантный)
      if let firstResult = result.first {
        cityNames[cityCode] = firstResult.name
      } else {
        // Если не нашли, используем код как fallback
        cityNames[cityCode] = cityCode
      }
    } catch {
      print("⚠️ Error loading city name for \(cityCode): \(error)")
      cityNames[cityCode] = cityCode // Fallback на код
    }
  }
  
  func getCityName(for cityCode: String) -> String {
    return cityNames[cityCode] ?? cityCode
  }
}
