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
              DetailFlightView()
            } label: {
              FotoCityView(
                direction: direction,
                cityName: viewModel.getCityName(for: direction.destination), photoSize: 190,
                viewModel: .init()
              )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
          }
          
        }
      }
    }
  }
}

#Preview {
  AllPopularDirectionsView(viewModel: .init())
}
