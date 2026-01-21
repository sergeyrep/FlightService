
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
  
  //для определения локации
  //@Published var popCodeIata: String?
  @Published var currentCity: UserIata? {
    didSet {
      if searchData.origin.isEmpty, let cityName = currentCity?.name {
        searchData.origin = cityName
      }
      //searchData.origin = currentCity?.name ?? ""
    }
  }
   
  @Published var searchData = FlightSearchData()
  @Published var focusedField: FocusField?
  @Published var showFlightResults = false
  
  @Published var scrollProgress: CGFloat = 0
  @Published var searchBarOffset: CGFloat = 0
  
  
  private let collapseThreshold: CGFloat = 0.8
  private let animationDuration: Double = 0.3
  
  let networkService: DefenitionLocationServiceProtocol = DefenitionLocationService.shared
  
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
  
  init() {
    Task {
      await defenitionLocale()
    }
    //self.networkService = networkService
  }
  
  private func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
    from + (to - from) * min(max(progress, 0), 1)
  }
}

extension MainViewModel {
  
//  func newCurrentLocation() async {
//    do {
//      let response = try await networkService.sendLocation()
//    } catch {
//      print("newCurrentLocation invalid")
//    }
//  }
  
  func defenitionLocale() async {
   
    do {
      let response = try await networkService.sendLocation()
      //self.cities = response
      await MainActor.run {
        self.currentCity = response
      }
    } catch {
      print("no locale")
      await MainActor.run {
        currentCity = UserIata(
          iata: "MOW",
          name: "Москва",
          countryName: "RU",
          coordinates: nil
        )
      }
    }
  }
}



