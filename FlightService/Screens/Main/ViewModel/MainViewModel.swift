
import Foundation
import Combine
import SwiftUI

enum FocusField {
  case origin
  case destination
}

struct FlightSearchData {
  var origin: String = ""
  var destination: String = ""
}

final class MainViewModel: ObservableObject {
  
  // MARK: - Зависимости (получаем через конструктор)
  private var locationService: DefenitionLocationServiceProtocol
  
  // MARK: - Published Properties
  @Published var currentCity: UserIata? {
    didSet {
      if searchData.origin.isEmpty, let cityName = currentCity?.name {
        searchData.origin = cityName
      }
    }
  }
  
  @Published var searchData = FlightSearchData()
  @Published var focusedField: FocusField?
  @Published var showFlightResults = false
  @Published var scrollProgress: CGFloat = 0
  @Published var searchBarOffset: CGFloat = 0
  
  // MARK: - Subject для отслеживания загрузки локации
  var isLocationLoaded: CurrentValueSubject<Bool, Never> = .init(false)
  
  // MARK: - Константы для анимации
  private let collapseThreshold: CGFloat = 0.8
  private let animationDuration: Double = 0.3
  
  init(locationService: DefenitionLocationServiceProtocol) {
    self.locationService = locationService
    
    Task {
      await defenitionLocale()
    }
  }
  
  func defenitionLocale() async {
    do {
      let response = try await locationService.sendLocation()
      self.currentCity = response
      self.isLocationLoaded.value = true
      print("📍 MainViewModel: локация загружена - \(response.name ?? "‼️ DAFAULT CITY")")
    } catch {
      print("no locale")
      //await MainActor.run {
      currentCity = UserIata(
        iata: "MOW",
        name: "Москва",
        countryName: "RU",
        coordinates: nil
      )
      self.isLocationLoaded.value = true
      // }
    }
  }
  
  func fetchFlightViewModel() -> FlightViewModel {
    makeFlightViewModel()
  }
  
  func fetchPopularViewModel() -> PopularViewModel {
    makePopularViewModel()
  }
  
  private func makeFlightViewModel() -> FlightViewModel {
    let factory = Factory.shared
    
    return FlightViewModel(
      networkService: factory.flightService,
      autocompletionCity: factory.searchIATAService,
      defenitionLocation: factory.locationService,
      initialDestinationName: "Hello",
      initialDestinationCode: "123"
    )
  }
  
  private func makePopularViewModel() -> PopularViewModel {
    let factory = Factory.shared
    
    return PopularViewModel(
      networkPopularService: factory.popularDirectionsService,
      networkLocationService: factory.locationService,
      isLocationLoaded: isLocationLoaded,
      cityNameService: factory.cityNameService,
    )
  }
}

extension MainViewModel {
  
  //MARK: -Вычисляемые свойства
  var shadowRadius: CGFloat {
    interpolate(from: 4, to: 8, progress: scrollProgress)
  }
  var shadowColor: CGFloat {
    interpolate(from: 0.3, to: 0.1, progress: scrollProgress)
  }
  var fromY: CGFloat {
    interpolate(from: 2, to: 4, progress: scrollProgress)
  }
  var shadowOffsetY: CGFloat {
    interpolate(from: 4, to: 8, progress: scrollProgress)
  }
  var isSearchBarCollapsed: Bool {
    scrollProgress <= collapseThreshold
  }
  var searchBarPadding: CGFloat {
    interpolate(from: 20, to: 10, progress: scrollProgress)
  }
  var searchBarHeight: CGFloat {
    interpolate(from: 110, to: 60, progress: scrollProgress)
  }
  
  private func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
    from + (to - from) * min(max(progress, 0), 1)
  }
}


