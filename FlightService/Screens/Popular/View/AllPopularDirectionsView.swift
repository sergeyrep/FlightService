import SwiftUI
import Combine

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
            let cityNameDestination = viewModel.cityNames[direction.destination] ?? "Unknown"
            NavigationLink {
              DetailPopularFlightView(
                cityCode: direction.destination,
                cityName: cityNameDestination
              )
            } label: {
              VStack {
                PhotoCityView(
                  cityCode: direction.destination,
                )
                .frame(width: 180, height: 180)
                
                Text(cityNameDestination)
              }
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
