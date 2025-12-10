//
//  TabView.swift
//  FlightService
//
//  Created by Сергей on 08.12.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      TabView {
        FlightView(viewModel: .init())
          .tabItem {
            Label("Flights", systemImage: "airplane")
          }
        HotelsView()
          .tabItem {
            Label("Hotels", systemImage: "bed.double.fill")
          }
        ImpressionsView()
          .tabItem {
            Label("Impressions", systemImage: "photo.circle")
          }
        Favorites()
          .tabItem {
            Label("Favorites", systemImage: "heart")
          }
        ProfileView()
          .tabItem {
            Label("Profile", systemImage: "person")
          }
      }
    }
}

#Preview {
  ContentView()
}
