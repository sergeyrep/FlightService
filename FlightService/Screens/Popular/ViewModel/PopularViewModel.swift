import Foundation
import SwiftUI
import Combine
import UIKit

final class PopularViewModel: ObservableObject {
  
  //MARK: -DI
  private var locationCancellable: AnyCancellable?
  
  //MARK: -Published
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
  let networkServiceLocation: DefenitionLocationServiceProtocol
  let networkServiceFoto: CityFotoServiceProtocol
  let networkServiceCurency: PopularDirectionsServiceProtocol
  
  init(
    networkServiceFoto: CityFotoServiceProtocol,
    networkServiceCurency: PopularDirectionsServiceProtocol,
    networkServiceSearchCityIata: SearchIATAServiceProtocol,
    networkLocationService: DefenitionLocationServiceProtocol,
    isLocationLoaded: CurrentValueSubject<Bool, Never>
  ) {
    self.networkServiceFoto = networkServiceFoto
    self.networkServiceCurency = networkServiceCurency
    self.networkServiceSearchCityIata = networkServiceSearchCityIata
    self.networkServiceLocation = networkLocationService
    
    setupLocation(isLocationLoaded)
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
      for direction in directions.prefix(15) {
        group.addTask {
          await self.loadCityName(for: direction.destination)
          //try? await Task.sleep(nanoseconds: 50_000_000)
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

//MARK: -расширение на получение локации
extension PopularViewModel {
  
  private func setupLocation(_ isLocationLoaded: CurrentValueSubject<Bool, Never>) {
    locationCancellable = isLocationLoaded
      .filter { $0 }
      .first()
      .sink { [weak self] value in
        guard let self = self else { return }
        print("📍 PopularViewModel: MainViewModel готов, можно грузить направления")
        self.sendLocation()
      }
  }
  
  private func sendLocation() {
    if let location = networkServiceLocation.currentLocation {
      self.currentCity = location
      print("Установлена локация: \(location.iata) - \(location.name ?? "MOW")")
      loadDirections()
    } else {
      self.currentCityIata = "MOW"
      print("📍 PopularViewModel: локация не найдена, используем MOW")
      loadDirections()
    }
    
    //        if let cashedLocation = networkServiceLocation.currentLocation {
    //         // self.currentCityIata = cashedLocation.iata
    //          self.currentCity = cashedLocation
    //          print("Установлена локация: \(cashedLocation.iata) - \(cashedLocation.name ?? "MOW")")
    //          //loadDirections()
    //        } else {
    //          self.currentCityIata = "MOW"
    //          print("Используется локация по умолчанию: MOW")
    //          loadDirections()
    //        }
  }
}
