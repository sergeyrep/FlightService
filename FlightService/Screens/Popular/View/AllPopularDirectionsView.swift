//
//  AllPopularDirectionsView.swift
//  FlightService
//
//  Created by Сергей on 25.12.2025.
//

import SwiftUI

struct AllPopularDirectionsView: View {
  
  @ObservedObject var viewModel: PopularViewModel
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns:
                    [
                      GridItem(.flexible()),
                      GridItem(.flexible())
                    ],
                  spacing: 10) {
          ForEach(viewModel.popularDirections) { direction in
            NavigationLink {
              DetailPopularFlightView(flight: direction, flightName: viewModel.currentCity)
            } label: {
              Image(systemName: "square.and.arrow.up")
//              PhotoCityView(
//                direction: direction,
//                cityName: viewModel.getCityName(for: direction.destination), photoSize: 190,
//                viewModel: .init(mainViewModel: .init())
//              )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
          }
        }
      }
      .padding(.top)
    }
  }
}

//#Preview {
//  AllPopularDirectionsView(viewModel: .init())
//}
