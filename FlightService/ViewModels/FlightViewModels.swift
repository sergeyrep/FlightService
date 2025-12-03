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
  
  @Published var activeSearchField: SearchField = .none
  
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
  
  func loadFlights() async {
    
    do {
      let response = try await networkService.sendRequestForFlight(
        origin: origin,
        destination: destination,
        departDate: departDate,
        returnDate: isOneWay ? nil : returnDate
      )
      
      self.flights = response
      
    } catch {
      print("❌ Error: \(error)")
    }
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
      .filter { $0.count >= 3 }
      .sink { [weak self] query in
        self?.searchCities(query: query, for: .origin)
      }
      .store(in: &cancellables)
  }
  
  func sinkSearchDestination() {
    $destination
      .debounce(for: .milliseconds(900), scheduler: RunLoop.main)
      .removeDuplicates()
      .filter { $0.count >= 3 }
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

