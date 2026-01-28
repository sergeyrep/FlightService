import Foundation
import SwiftUI
import Combine
import UIKit

final class PopularViewModel: ObservableObject {
  //MARK: -Published
  @Published var popularDirections: [PopularDirectionsModel] = []
  @Published var isLoading: Bool = false
  @Published var cityNames: [String: String] = [:]
  
  @Published var currentCity: UserIata? {
    didSet {
      if let currentIata = currentCity?.iata {
        currentCityIata = currentIata
      }
    }
  }
  
  private var currentCityIata: String = "MOW"
  
  //MARK: -DI
  private var locationCancellable: AnyCancellable?
  
  //MARK: -NetworcService
  private let networkLocationService: DefenitionLocationServiceProtocol
  private let networkPopularService: PopularDirectionsServiceProtocol
  private let cityNameService: CityNameServiceProtocol
  
  init(
    networkPopularService: PopularDirectionsServiceProtocol,
    networkLocationService: DefenitionLocationServiceProtocol,
    isLocationLoaded: CurrentValueSubject<Bool, Never>,
    cityNameService: CityNameServiceProtocol
  ) {
    self.networkPopularService = networkPopularService
    self.networkLocationService = networkLocationService
    self.cityNameService = cityNameService
    
    setupLocation(isLocationLoaded)
  }
  
  //MARK: - LoadCityNames
  func preloadCityNames() async {
    for direction in popularDirections {
      let name = await getCityName(for: direction.destination)
      cityNames[direction.destination] = name
    }
  }
  
  private func getCityName(for iata: String) async -> String {
    return await cityNameService.getCityName(for: iata)
  }
  
  //MARK: -LoadFunc
  private func loadDirections() {
    Task {
      await loadPopularDirections()
    }
  }
  
  @MainActor
  private func loadPopularDirections() async {
    
    isLoading = true
    defer { isLoading = false }
    
    do {
      let response = try await networkPopularService.sendPopularDirections(
        origin: currentCityIata,
        currency: "rub"
      )
      self.popularDirections = response
      
      let iatas = response.map { $0.destination }
      await cityNameService.preloadCityNames(for: iatas)
      
    } catch {
      print("❌ Error: \(error)")
    }
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
    if let location = networkLocationService.currentLocation {
      self.currentCity = location
      print("Установлена локация: \(location.iata) - \(location.name ?? "MOW")")
      loadDirections()
    } else {
      self.currentCityIata = "MOW"
      print("📍 PopularViewModel: локация не найдена, используем MOW")
      loadDirections()
    }
  }
}
