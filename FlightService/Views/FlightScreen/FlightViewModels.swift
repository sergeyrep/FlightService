//
//  FlightViewModels.swift
//  FlightService
//
//  Created by Сергей on 27.11.2025.
//

import Foundation
import Combine
import SwiftUI

enum SearchField {
  case origin, destination, none
}

final class FlightViewModel: ObservableObject {
  
  @Published var flights: [Flight] = []
  @Published var suggestionsOrigin: [CitySuggestion] = []
  @Published var suggestionsDestination: [CitySuggestion] = []
  
  @Published var origin: String = ""
  @Published var destination: String = ""
  @Published var departDate = Date()
  @Published var returnDate: Date? = nil
  @Published var isOneWay: Bool = true
  @Published var isLoading: Bool = false
  @Published var activeSearchField: SearchField = .none
  
  private(set) var originIata: String = ""
  private(set) var destinationIata: String = ""
  
  private var cancellables = Set<AnyCancellable>()
  
  let networkService: FlightServiceProtocol
  let autocompleteCity: SearchIATAServiceProtocol
  
  init(
    networkService: FlightServiceProtocol = FlightService(),
    autocompletionCity: SearchIATAServiceProtocol = SearchIATAService()
  ) {
    self.networkService = networkService
    self.autocompleteCity = autocompletionCity
    
    sinkSearchOrigin()
    sinkSearchDestination()
  }
  
  func loadAllFlights() async {
    guard !origin.isEmpty else {
      print("от куда летим")
      return
    }
    
    await MainActor.run {
      isLoading = true
    }
    defer { isLoading = false }
    
    do {
      let response = try await networkService.sendRequestForFlight(
        origin: originIata,
        destination: destinationIata,
        departDate: departDate,
        returnDate: isOneWay ? nil : returnDate
      )
      
      await MainActor.run {
        self.flights = response
      }
      
    } catch {
      print("❌ Error: \(error)")
    }
  }
  
  func loadFlights() async {
    
    guard !origin.isEmpty, !destination.isEmpty else {
      print("code iata is empty")
      return
    }
    
    await MainActor.run {
      isLoading = true
    }
    defer { isLoading = false }
    
    do {
      let response = try await networkService.sendRequestForFlight(
        origin: originIata,
        destination: destinationIata,
        departDate: departDate,
        returnDate: isOneWay ? nil : returnDate
      )
      
      await MainActor.run {
        self.flights = response
      }
      
    } catch {
      print("❌ Error: \(error)")
    }
  }
}

extension FlightViewModel {
  func selectOrigin(_ suggestion: CitySuggestion) {
    origin = suggestion.name
    originIata = suggestion.code
    suggestionsOrigin = []
  }
  
  func selectDestination(_ suggestion: CitySuggestion) {
    destination = suggestion.name
    destinationIata = suggestion.code
    suggestionsDestination = []
  }
}

extension FlightViewModel {
  func searchCities(query: String, for field: SearchField) {
    
    Task {
      
      do {
        let result = try await autocompleteCity.searchCity(query: query)
        
        await MainActor.run {
          switch field {
          case .origin:
            self.suggestionsOrigin = result
          case .destination:
            self.suggestionsDestination = result
          case .none:
            break
          }
        }
      } catch {
        print("Search error: \(error)")
      }
    }
  }
  
  func sinkSearchOrigin() {
    $origin
      .debounce(for: .milliseconds(900), scheduler: RunLoop.main)
      .removeDuplicates()
      .filter { $0.count >= 2 }
      .sink { [weak self] query in
        self?.searchCities(query: query, for: .origin)
      }
      .store(in: &cancellables)
  }
  
  func sinkSearchDestination() {
    $destination
      .debounce(for: .milliseconds(900), scheduler: RunLoop.main)
      .removeDuplicates()
      .filter { $0.count >= 2 }
      .sink { [weak self] query in
        self?.searchCities(query: query, for: .destination)
      }
      .store(in: &cancellables)
  }
}

extension Date {
  func addingDays(_ days: Int) -> Date {
    Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
  }
}


