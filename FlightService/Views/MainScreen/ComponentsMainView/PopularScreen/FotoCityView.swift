//
//  FotoCityView.swift
//  FlightService
//
//  Created by Сергей on 25.12.2025.
//

import SwiftUI

struct FotoCityView: View {
  
  let direction: PopularDirectionsModel
  let cityName: String
  let photoSize: CGFloat
  @ObservedObject var viewModel: PopularViewModel
  
  var body: some View {
    VStack {
      AsyncImage(url: URL(string: viewModel.loadFoto(cityCode: direction.destination))) { phase in
        switch phase {
        case .success(let image):
          image
            .resizable()
            .cornerRadius(20)
            .frame(width: photoSize, height: photoSize)
        case .failure:
          Image(systemName: "person.fill")
            .resizable()
            .cornerRadius(20)
            .frame(width: 120, height: 120)
        case .empty:
          ProgressView()
            .cornerRadius(20)
            .frame(width: 120, height: 120)
        @unknown default:
          EmptyView()
        }
      }
      
      Text(cityName.isEmpty ? direction.destination : cityName)
        .font(.caption)
        .fontWeight(.semibold)
        .lineLimit(1)
      HStack {
        Image(systemName: "airplane.up.forward")
          .font(.caption2)
        Text("от \(direction.price) ₽")
      }
    }
  }
}

#Preview {
  let cityName = "Москва"
  FotoCityView(direction: .init(origin: "MOW", destination: "LON", price: 2), cityName: cityName, photoSize: 100, viewModel: .init())
}
