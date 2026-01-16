import Foundation
import Combine
import UIKit

final class PopularViewModel: ObservableObject {
  
  @Published var popularDirections: [PopularDirectionsModel] = []
  @Published var isLoading: Bool = false
  
  @Published var popularDirectionsNameCity: [CitySuggestion] = []
  @Published var cityNames: [String: String] = [:]
  
  @Published var currentCity: UserIata? {
    didSet {
      if let currentIata = currentCity?.iata {
        currentCityIata = currentIata
      }
    }
  }
  private var currentCityIata: String = "MOW"
  
  private var cancellables = Set<AnyCancellable>()
  private var photoURLCache: [String: String] = [:]
  
  //MARK: -NetworcServices
  let networkServiceSearchCityIata: SearchIATAServiceProtocol
  let networkServiceLocation: DefenitionLocationServiceProtocol = DefenitionLocationService.shared
  
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
    
    sendLocation()
  }
  
  //MARK: -LoadFunc
  func loadDirections() {
    Task {
      await loadPopularDirections()
    }
  }
  
  @MainActor
  func loadPopularDirections() async {
    
    isLoading = true
    defer { isLoading = false }
    
    do {
      let response = try await networkServiceCurency.sendPopularDirections(
        origin: currentCityIata,
        currency: "rub"
      )
      self.popularDirections = response
      
      await loadCityNames(for: response)
      
    } catch {
      print("❌ Error: \(error)")
    }
  }
  
  func loadFoto(cityCode: String) -> String {
    
    if let cashed = photoURLCache[cityCode] {
      return cashed
    }
    
    let url = "https://photo.hotellook.com/static/cities/960x720/\(cityCode).jpg"
    photoURLCache[cityCode] = url
    return url
  }
}

//MARK: -Extension
extension PopularViewModel {
  
  @MainActor
  private func loadCityNames(for directions: [PopularDirectionsModel]) async {
    //все запросы параллельно
    await withTaskGroup(of: Void.self) { group in
      for direction in directions {
        group.addTask {
          await self.loadCityName(for: direction.destination)
        }
      }
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

extension PopularViewModel {
  
  func sendLocation() {
    if let cashedLocation = networkServiceLocation.currentLocation {
      self.currentCityIata = cashedLocation.iata
      print("Установлена локация: \(cashedLocation.iata) - \(cashedLocation.name ?? "MOW")")
      loadDirections()
    } else {
      self.currentCityIata = "MOW"
      print("Используется локация по умолчанию: MOW")
      loadDirections()
    }
  }
}
