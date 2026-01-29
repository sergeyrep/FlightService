import Foundation
import Combine
import SwiftUI

struct PopularDirectionsView: View {
  
  @StateObject var viewModel: PopularViewModel
  
  @State private var showAll: Bool = false
  
  var body: some View {
    ZStack {
      Color(.white)
      VStack {
        header
        content
        buttonShowAll
      }
    }
    .cornerRadius(20)
    .padding()
    .sheet(isPresented: $showAll) {
      AllPopularDirectionsView(viewModel: viewModel)
    }
  }
  
  private var buttonShowAll: some View {
    Button("Показать все места") {
      showAll = true
    }
    .frame(maxWidth: .infinity, minHeight: 45)
    .background(Color(.gray.opacity(0.1)))
    .foregroundColor(.black)
    .cornerRadius(20)
    .padding(.bottom, 8)
    .padding(.horizontal, 8)
  }
  
  private var content: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 8) {
        ForEach(viewModel.popularDirections) { direction in
          let cityName = viewModel.cityNames[direction.destination] ?? direction.destination
          NavigationLink {
            DetailPopularFlightView(
              cityCode: direction.destination,
              cityName: cityName,
              price: direction.price
            )
          } label: {
            VStack {
              PhotoCityView(
                cityCode: direction.destination,
              )
              .foregroundColor(.black)
              .frame(width: 150, height: 150)
              
              if !viewModel.isLoading {
                TitlePopularCard(cityName: cityName, price: direction.price)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.horizontal, 8)
              } else {
                ProgressView()
                  .controlSize(.mini)
              }
            }
            .task {
              await viewModel.preloadCityNames()
            }
          }
        }
      }
    }
    .padding(.horizontal, 8)
  }
  
  private var header: some View {
    Text("Популярные направления, \(viewModel.popularDirections.count)")
      .font(.system(size: 20, design: .serif))
      .fontWeight(.bold)
      .foregroundColor(.black)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 8)
      .padding(.horizontal, 8)
  }
}

struct TitlePopularCard: View {
  let cityName: String
  let price: Int
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(cityName)
      HStack {
        Image(systemName: "airplane.up.right")
          .frame(width: 10, height: 10)
        Text("от \(price)₽")
      }
    }
    .foregroundColor(.black)
    .font(.system(size: 12))
  }
}

//#Preview {
//  let factory = Factory.shared
//  PopularDirectionsView(viewModel: .init(networkPopularService: factory.popularDirectionsService, networkLocationService: factory.locationService, isLocationLoaded: CurrentValueSubject<Bool, Never>(false), cityNameService: factory.cityNameService))
//}
