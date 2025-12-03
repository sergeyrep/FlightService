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
      LazyVStack {
        Toggle("OneWay", isOn: $viewModel.isOneWay)
          .padding()
        datePickers
        cityField(
          title: "От куда летим",
          icon: "airplane.departure",
          text: $viewModel.origin,
          suggestions: viewModel.suggestionsOrigin,
          field: .origin
        )
        cityField(
          title: "Куда летим",
          icon: "airplane.arrival",
          text: $viewModel.destination,
          suggestions: viewModel.suggestionsDestination,
          field: .destination
        )
        
        //ifFocused(for: .origin)
        
        
        
      //  ifFocused(for: .destination)
        
        ForEach(viewModel.flights) { flight in
          VStack(alignment: .leading) {
            Text(flight.airline)
            Text("Time: \(flight.departureTime)")
            Text("Price: \(flight.price) \(flight.currency.uppercased())")
            Text("\(flight.origin) --> \( flight.destination)")
            Text("Return: \(String(describing: flight.returnTime))")
          }
        }
        Button("Show flight") {
          Task {
            await viewModel.loadFlights()
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func ifFocused(for field: SearchField) -> some View {
    switch field {
    case .origin:
      if focusedField == .origin && !viewModel.suggestionsOrigin.isEmpty {
        SuggestionsList(
          suggestions: viewModel.suggestionsOrigin,
          onSelect: { suggestion in
            viewModel.origin = suggestion.code
            viewModel.suggestionsOrigin = []
            focusedField = nil
          }
        )
      }
    case .destination:
      if focusedField == .destination && !viewModel.suggestionsDestination.isEmpty {
        SuggestionsList(
          suggestions: viewModel.suggestionsDestination,
          onSelect: { suggestion in
            viewModel.destination = suggestion.code
            viewModel.suggestionsDestination = []
            focusedField = nil
          }
        )
      }
    case .none:
      EmptyView()
    }
  }
  
  private func cityField(
    title: String,
    icon: String,
    text: Binding<String>,
    suggestions: [CitySuggestion],
    field: SearchField
  ) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Image(systemName: icon)
          .foregroundColor(.blue)
        Text(title)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      TextField("какойто текст", text: text)
        .focused($focusedField, equals: field)
        .textFieldStyle(.roundedBorder)
        .onTapGesture {
          focusedField = field
          //можно добавить очистку филдов
        }
      if focusedField == field && !suggestions.isEmpty {
        SuggestionsList(
          suggestions: suggestions,
          onSelect: { suggestion in
            text.wrappedValue = suggestion.code
            viewModel.suggestionsDestination = []
            focusedField = nil
          }
        )
      }
    }
  }
  
//  private var textFields: some View {
//    TextField("Origin", text: $viewModel.origin)
//      .focused($focusedField, equals: .origin)
//      .textFieldStyle(.roundedBorder)
//      .padding(.horizontal)
//      .onTapGesture {
//        viewModel.activeSearchField = .origin
//      }
//    TextField("Destination", text: $viewModel.destination)
//      .focused($focusedField, equals: .destination)
//      .textFieldStyle(.roundedBorder)
//      .padding(.horizontal)
//      .onTapGesture {
//        viewModel.activeSearchField = .destination
//      }
//  }
  
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

