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
    NavigationStack {
      ScrollView {
        VStack {
          originFields
          Divider()
          destinationFields
        }
        .background(Color(.white))
        .cornerRadius(20)
        .padding()
        
        datePickers
        
        ScrollView(.horizontal) {
          
        }
        
        Button("Показать рейсы") {
          Task {
            await viewModel.loadFlights()
          }
        }
        .foregroundStyle(.black)
        .padding(10)
        .background(.blue.opacity(0.3))
        .cornerRadius(20)
        
        cardFlight
      }
      .background(.gray.opacity(0.3))
    }
  }
  
  @ViewBuilder
  private var originFields: some View {
    cityField(
      title: "Откуда",
      icon: focusedField == .origin ? .magnifyingGlass : .origin,
      text: $viewModel.origin,
      suggestions: viewModel.suggestionsOrigin,
      field: .origin,
      onSelect: viewModel.selectOrigin
    )
  }
  
  @ViewBuilder
  private var destinationFields: some View {
    HStack {
      cityField(
        title: "Куда",
        icon: focusedField == .destination ? .magnifyingGlass : .destination,
        text: $viewModel.destination,
        suggestions: viewModel.suggestionsDestination,
        field: .destination,
        onSelect: viewModel.selectDestination
      )
      Button("Не важно куда") {
        Task {
          await viewModel.loadAllFlights()
        }
      }
      .font(.system(size: 10))
      .padding(3)
      .background(.blue.opacity(0.3))
      .cornerRadius(20)
      .padding(3)
    }
  }
  
  private var toogleOneWay: some View {
    Toggle(viewModel.isOneWay ? "Туда-Обратно" : "В одну сторону", isOn: $viewModel.isOneWay)
      .toggleStyle(.button)
  }
  
  private var cardFlight: some View {
    ForEach(viewModel.flights) { flight in
      NavigationLink {
        DetailFlightView()
      } label: {
        VStack(alignment: .leading) {
          Text(flight.airline)
          Text("Time: \(flight.departureTime)")
          Text("Price: \(flight.price) \(flight.currency.uppercased())")
          Text("\(flight.origin) --> \( flight.destination)")
          Text("Return: \(String(describing: flight.returnTime))")
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
      }
    }
  }
  
  @ViewBuilder
  private func cityField(
    title: String,
    icon: IconField,
    text: Binding<String>,
    suggestions: [CitySuggestion],
    field: SearchField,
    onSelect: @escaping (CitySuggestion) -> Void
  ) -> some View {
    HStack {
      Image(systemName: icon.rawValue)
        .padding(8)
      TextField(title, text: text)
        .focused($focusedField, equals: field)
        .padding(10)
    }
    
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
    VStack(alignment: .leading, spacing: 0) {
      DatePicker(
        "Дата вылета",
        selection: $viewModel.departDate,
        in: Date()...,
        displayedComponents: .date
      )
      .onChange(of: viewModel.departDate) {
        Task {
          await viewModel.loadFlights()
        }
      }
      toogleOneWay
      if !viewModel.isOneWay {
        DatePicker(
          "Дата возврата",
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
    .padding(8)
    .background(.white)
    .cornerRadius(20)
    .padding()
  }
}

enum IconField: String {
  case origin = "airplane.departure"
  case destination = "airplane.arrival"
  case magnifyingGlass = "magnifyingglass"
}

#Preview {
  FlightView(viewModel: .init())
}


