import Foundation
import Combine

protocol CityNameServiceProtocol {
  func preloadCityNames(for codes: [String]) async
  func getCityName(for cityCode: String) async -> String
}

final class CityNameService: CityNameServiceProtocol {
  
  private var cache: [String: String] = [:]
  private let networkService: SearchIATAServiceProtocol
  
  init(networkService: SearchIATAServiceProtocol) {
    self.networkService = networkService
    
  }
  
  func getCityName(for cityCode: String) async -> String {
    if let cached = cache[cityCode] {
      return cached
    }
    
    do {
      let suggestion = try await networkService.searchCity(query: cityCode)
      let name = suggestion.first?.name ?? cityCode
      cache[cityCode] = name
      return name
    } catch {
      return cityCode
    }
  }
  
  func preloadCityNames(for codes: [String]) async {
    await withTaskGroup(of: Void.self) { group in
      for code in codes {
        group.addTask {
          _ = await self.getCityName(for: code)
        }
      }
    }
  }
}
