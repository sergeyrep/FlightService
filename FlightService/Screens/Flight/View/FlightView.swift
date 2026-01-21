import SwiftUI

struct FlightView: View {
  @StateObject var viewModel: FlightViewModel
  @FocusState private var focusedField: SearchField?
  
  var body: some View {
    NavigationStack {
      ScrollView {
        searchFlights
        datePickers
        ScrollView(.horizontal) {
          
        }
        buttonSearch        
        FlightCard(flights: viewModel.flights)
      }
      .background(.gray.opacity(0.3))
    }
  }
  
  private var buttonSearch: some View {
    Button("Показать рейсы") {
      Task {
        await viewModel.loadFlights()
      }
    }
    .foregroundStyle(.black)
    .padding(10)
    .background(.blue.opacity(0.3))
    .cornerRadius(20)
  }
  
  private var searchFlights: some View {
    VStack {
      SearchTextField(
        title: "Откуда",
        icon: .origin,
        text: $viewModel.origin,
        suggestions: viewModel.suggestionsOrigin,
        field: .origin,
        focusedField: $focusedField,
        onSuggestionSelect: viewModel.selectOrigin
      )
      Divider()
      SearchTextField(
        title: "Куда",
        icon: .destination,
        text: $viewModel.destination,
        suggestions: viewModel.suggestionsDestination,
        field: .destination,
        focusedField: $focusedField,
        onSuggestionSelect: viewModel.selectDestination
      )
    }
    .background(Color(.white))
    .cornerRadius(20)
    .padding()
  }
  
  private var toogleOneWay: some View {
    Toggle(viewModel.isOneWay ? "Туда-Обратно" : "В одну сторону", isOn: $viewModel.isOneWay)
      .toggleStyle(.button)
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


