//
//  FlightCard.swift
//  FlightService
//
//  Created by Сергей on 21.01.2026.
//

import SwiftUI

struct FlightCard: View {
  let flights: [Flight]
  
  var body: some View {
    ForEach(flights) { flight in
      NavigationLink {
        DetailFlightView(flight: flight)
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
}

#Preview {
  FlightCard(flights: .init())
}

//private var cardFlight: some View {
//  ForEach(viewModel.flights) { flight in
//    NavigationLink {
//      DetailFlightView(flight: flight)
//    } label: {
//      VStack(alignment: .leading) {
//        Text(flight.airline)
//        Text("Time: \(flight.departureTime)")
//        Text("Price: \(flight.price) \(flight.currency.uppercased())")
//        Text("\(flight.origin) --> \( flight.destination)")
//        Text("Return: \(String(describing: flight.returnTime))")
//      }
//      .padding()
//      .background(.white)
//      .cornerRadius(20)
//    }
//  }
//}
