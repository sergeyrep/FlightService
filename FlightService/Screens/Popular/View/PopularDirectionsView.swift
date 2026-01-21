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
          .frame(height: 180)
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
          NavigationLink {
            DetailPopularFlightView(flight: direction)
          } label: {
            PhotoCityView(
              direction: direction,
              cityName: viewModel.getCityName(for: direction.destination), photoSize: 120,
              viewModel: viewModel
            )
            .foregroundColor(.black)
          }
        }
      }
    }
    .padding(.horizontal, 8)
  }
  
  private var header: some View {
    Text("Популярные направления")
      .font(.system(size: 20, design: .serif))
      .fontWeight(.bold)
      .foregroundColor(.black)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 8)
      .padding(.horizontal, 8)
  }
}

struct DetailPopularFlightView: View {
  
  let flight: PopularDirectionsModel
  
  var body: some View {
    PhotoCityView(direction: flight, cityName: flight.destination, photoSize: 150, viewModel: .init())
    Text(flight.origin)
  }
}


#Preview {
  PopularDirectionsView(viewModel: .init())
}
