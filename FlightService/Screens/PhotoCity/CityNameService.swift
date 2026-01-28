import Foundation
import Combine

protocol CityNameServiceProtocol {
  //func loadCityNames(for directions: [PopularDirectionsModel]) async
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
  
//  func getCityName(for cityCode: String) async -> String {
//    return cityNames[cityCode] ?? cityCode
//  }
//  
//  @MainActor
//  func loadCityNames(for directions: [PopularDirectionsModel]) async {
//    for direction in directions {
//      await self.loadCityName(for: direction.destination)
//    }
//  }
//  
//  @MainActor
//  func loadCityName(for iata: String) async {
//    guard cityNames[iata] == nil else { return }
//    
//    do {
//      let name = try await networkService.searchCity(query: iata)
//      
//      if let cityName = name.first {
//        cityNames[iata] = cityName.name
//      } else {
//        cityNames[iata] = iata
//      }
//    } catch {
//      print("netu city suggestiona")
//      cityNames[iata] = iata
//    }
//  }
  
  
  
  
  //  private func loadCityName(for cityCode: String) async {
  //    // Если уже загружено - пропускаем
  //    guard cityNames[cityCode] == nil else { return }
  //
  //    do {
  //      let result = try await networkService.searchCity(query: cityCode)
  //
//      // Берем первый результат (наиболее релевантный)
//      if let firstResult = result.first {
//        cityNames[cityCode] = firstResult.name
//      } else {
//        // Если не нашли, используем код как fallback
//        cityNames[cityCode] = cityCode
//      }
//    } catch {
//      print("⚠️ Error loading city name for \(cityCode): \(error)")
//      cityNames[cityCode] = cityCode // Fallback на код
//    }
//  }
}
  
  
//  func getName(for cityCode: String) async -> String {
//    if let cahed = cache[cityCode] { return cahed }
//    
//    do {
//      let result = try await networkService.searchCity(query: cityCode)
//      let name = result.first?.name ?? cityCode
//      cache[cityCode] = name
//      return name
//    } catch {
//      return cityCode
//    }
//  }
//  
//  func preloadNames(for codes: [String]) async {
//    await withTaskGroup(of: Void.self) { group in
//      for code in codes {
//        group.addTask {
//          _ = await self.getName(for: code)
//        }
//      }
//    }
//  }

  
//  let cityCode: String
//  
//  @Published var cityNames: [String: String] = [:]
//  
//  private var cancellables = Set<AnyCancellable>()
//  private var photoURLCache: [String: String] = [:]
//  
//  
//  let directionCityCode: PopularDirectionsModel
//  //var directions: String = ""
//  
//  let networkServiceSearchCityIata: SearchIATAServiceProtocol
//  
//  init(
//    cityCode: String,
//    networkServiceSearchCityIata: SearchIATAServiceProtocol,
//    directionCityCode: PopularDirectionsModel,
//  ) {
//    self.cityCode = cityCode
//    self.networkServiceSearchCityIata = networkServiceSearchCityIata
//    self.directionCityCode = directionCityCode
//  }
//  
// 
//  
//  func loadFoto() -> String {
//    if let cashed = photoURLCache[directionCityCode.destination] {
//      return cashed
//    }
//    
//    let url = "https://photo.hotellook.com/static/cities/960x720/\(directionCityCode.destination).jpg"
//    photoURLCache[directionCityCode.destination] = url
//    //directions = cityCode
//    return url
//  }
//}
//
//extension CityNameService {
//
//  @MainActor
//  private func loadCityNames(for directions: [PopularDirectionsModel]) async {
//    //все запросы параллельно
//    await withTaskGroup(of: Void.self) { group in
//      for direction in directions {
//        group.addTask {
//          await self.loadCityName(for: direction.destination)
//        }
//      }
//    }
//  }
//  
//  @MainActor
//  private func loadCityName(for cityCode: String) async {
//    // Если уже загружено - пропускаем
//    if cityNames[cityCode] != nil { return }
//    
//    do {
//      let result = try await networkServiceSearchCityIata.searchCity(query: cityCode)
//      
//      // Берем первый результат (наиболее релевантный)
//      if let firstResult = result.first {
//        cityNames[cityCode] = firstResult.name
//      } else {
//        // Если не нашли, используем код как fallback
//        cityNames[cityCode] = cityCode
//      }
//    } catch {
//      print("⚠️ Error loading city name for \(cityCode): \(error)")
//      cityNames[cityCode] = cityCode // Fallback на код
//    }
//  }
//  
//  func getCityName(for cityCode: String) -> String {
//    return cityNames[cityCode] ?? cityCode
//  }
//}
