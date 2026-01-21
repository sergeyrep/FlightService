//
//  ComponentsMainView.swift
//  FlightService
//
//  Created by Сергей on 11.12.2025.
//

import SwiftUI

struct ComponentsMainView: View {
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  InterestingContent()
}

struct DestinationCard: View {
  let name: String
  let price: String
  
  init(name: String, price: String) {
    self.name = name
    self.price = price
  }
  
  init(index: Int) {
    self.name = "Направление \(index + 1)"
    self.price = "от \(10000 + index * 2000) ₽"
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.blue.opacity(0.1))
        .frame(height: 120)
        .overlay(
          Image(systemName: "airplane")
            .font(.largeTitle)
            .foregroundColor(.blue)
        )
      
      Text(name)
        .font(.headline)
      
      Text(price)
        .font(.subheadline)
        .foregroundColor(.blue)
        .fontWeight(.semibold)
    }
    .padding()
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
  }
}


struct SalesFlight: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color.orange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
      VStack {
        Text("Горячие билеты")
          .font(.system(size: 20, design: .serif))
          .fontWeight(.bold)
          .foregroundColor(.black)
          .padding(.top, 10)
        Text("Скоро разберут")
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(0..<50) { item in
              ZStack {
                Rectangle()
                  .fill(Color.white)
                  .cornerRadius(20)
                HStack {
                  Image(systemName: "photo.artframe")
                    .resizable()
                    .frame(width: 90, height: 90)
                  Text("Name")
                  Text("City")
                  Text("\(Image(systemName: "airplane.circle.fill")) 14500руб")
                }
                .padding()
              }
            }
          }
        }
        .ignoresSafeArea()
        Button("Больше жарких билетов") {
          
        }
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 10)
      }
    }
    .cornerRadius(20)
    .padding()
  }
}

struct WeekendFlight: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color.blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
      VStack {
        Text("Куда улетель на выходные")
          .font(.system(size: 20, design: .serif))
          .fontWeight(.bold)
          .foregroundColor(.black)
          .padding(.top, 10)
        
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(0..<50) { item in
              ZStack {
                Rectangle()
                  .fill(Color.white)
                  .cornerRadius(20)
                HStack {
                  Image(systemName: "photo.artframe")
                    .resizable()
                    .frame(width: 90, height: 90)
                  Text("Name")
                  Text("City")
                  Text("\(Image(systemName: "airplane.circle.fill")) 14500руб")
                }
                .padding()
              }
            }
          }
        }
        .ignoresSafeArea()
        
        Button("Больше жарких билетов") {
          
        }
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 10)
      }
    }
    .cornerRadius(20)
    .padding()
  }
}

struct InterestingContent: View {
  
  let fotosCities = ["https://photo.hotellook.com/static/cities/960x720/MOW.jpg", "https://photo.hotellook.com/static/cities/960x720/KZN.jpg", "https://photo.hotellook.com/static/cities/960x720/LON.jpg", "https://photo.hotellook.com/static/cities/960x720/KJA.jpg", "https://photo.hotellook.com/static/cities/960x720/ABA.jpg"]
  
  var body: some View {
    ZStack {
      Color(.gray)
      
      VStack(alignment: .leading) {
        Text("Увидеть без визы")
          .font(.system(size: 20, design: .serif))
          .fontWeight(.bold)
          .foregroundColor(.black)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(fotosCities, id: \.self) { foto in
              
              VStack {
                if let url = URL(string: foto) {
                  AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                      ProfileView()
                    case .success(let image):
                      image
                        .resizable()
                    case .failure:
                      Image(systemName: "person.fill")
                    @unknown default:
                      EmptyView()
                    }
                  }
                  //.resizable()
                  .frame(width: 90, height: 90)
                  Text("Name")
                  Text("City")
                  Text("\(Image(systemName: "airplane.circle.fill")) 14500руб")
                } else {
                  Image(systemName: "person.fill")
                }
              }
            }
          }
        }
        Button("Показать все места") {
          
        }
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity, alignment: .center)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding()
    }
    .cornerRadius(20)
    .padding()
  }
}


