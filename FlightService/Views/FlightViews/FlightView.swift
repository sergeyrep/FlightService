//
//  FlightView.swift
//  FlightService
//
//  Created by Сергей on 27.11.2025.
//

import SwiftUI

struct FlightView: View {
  @StateObject var viewModel: FlightViewModel
  @FocusState private var focusedField: SearchField?

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
        originFields        
        Section(header: destinationFields) {
          toogleOneWay
          Button("Show flight") {
            Task {
              await viewModel.loadFlights()
            }
          }
          cardFlight
        }
      }
    }
  }

  @ViewBuilder
  private var originFields: some View {
      datePickers
      cityField(
        title: "От куда",
        icon: "airplane.departure",
        text: $viewModel.origin,
        suggestions: viewModel.suggestionsOrigin,
        field: .origin,
        onSelect: viewModel.selectOrigin
      )
  }
  
  private var destinationFields: some View {
    cityField(
      title: "Куда",
      icon: "airplane.arrival",
      text: $viewModel.destination,
      suggestions: viewModel.suggestionsDestination,
      field: .destination,
      onSelect: viewModel.selectDestination
    )
  }

  private var toogleOneWay: some View {
    Toggle(viewModel.isOneWay ? "В одну сторону" :"Туда-Обратно", isOn: $viewModel.isOneWay)
      .toggleStyle(.button)
      .padding()
  }
  
  private var cardFlight: some View {
    ForEach(viewModel.flights) { flight in
      VStack(alignment: .leading) {
        Text(flight.airline)
        Text("Time: \(flight.departureTime)")
        Text("Price: \(flight.price) \(flight.currency.uppercased())")
        Text("\(flight.origin) --> \( flight.destination)")
        Text("Return: \(String(describing: flight.returnTime))")
      }
    }
  }

  @ViewBuilder
  private func cityField(
    title: String,
    icon: String,
    text: Binding<String>,
    suggestions: [CitySuggestion],
    field: SearchField,
    onSelect: @escaping (CitySuggestion) -> Void
  ) -> some View {
    
    TextField(title, text: text)
      .focused($focusedField, equals: field)
      .textFieldStyle(.roundedBorder)
    if focusedField == field && !suggestions.isEmpty {
      SuggestionsList(
        suggestions: suggestions,
        onSelect: { suggestion in
          text.wrappedValue = suggestion.code
          viewModel.suggestionsDestination = []
          focusedField = nil
          onSelect(suggestion)
        }
      )
    }
  }

  private var datePickers: some View {
    Section("Dates") {
      DatePicker(
        "Departure date",
        selection: $viewModel.departDate,
        in: Date()...,
        displayedComponents: .date
      )
      .onChange(of: viewModel.departDate) {
        Task {
          await viewModel.loadFlights()
        }
      }
      if !viewModel.isOneWay {
        DatePicker(
          "Return date",
          selection: Binding(
            get: { viewModel.returnDate ?? Date().addingTimeInterval(86400 * 7) },

            set: { viewModel.returnDate = $0 }
          ),
          in: viewModel.departDate...,
          displayedComponents: .date
        )
        .onChange(of: viewModel.returnDate) {
          Task {
            await viewModel.loadFlights()
          }
        }
      }
    }
  }
}

#Preview {
  FlightView(viewModel: .init())
}


