import Foundation
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
              cityName: cityName
            )
          } label: {
            VStack {
              PhotoCityView(
                cityCode: direction.destination,
              )
              .foregroundColor(.black)
              .frame(width: 150, height: 150)
              
              if !viewModel.isLoading {
                Text(cityName)
                Text("от \(direction.price)₽")
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

//#Preview {
//  PopularDirectionsView(viewModel: .init())
//}
