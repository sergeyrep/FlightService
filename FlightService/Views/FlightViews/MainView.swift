////
////  MainView.swift
////  FlightService
////
////  Created by Сергей on 09.12.2025.
////
//
import SwiftUI

enum FocusField {
  case origin
  case departure
}

struct MainView: View {
  
  @State private var text: String = ""
  @State private var text2: String = ""
  @FocusState private var isFocused: FocusField?
  
  @State private var showFlight: Bool = false
  
  var body: some View {
    ScrollView {
      header
      InterestingContent()
      SalesFlight()
      WeekendFlight()
    }
    .background(.gray.opacity(0.3))
    .ignoresSafeArea()
    .sheet(isPresented: $showFlight) {
      FlightView(viewModel: .init())
    }
    .onChange(of: isFocused) { _, newValue in
      if newValue == .origin {
        showFlight = true
      }
    }
  }
  
  private var header: some View {
    ZStack {
      headScrols
      searchBar
    }
    .padding(.bottom, 100)
  }
  
  private var searchBar: some View {
    Section {
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.white)
        ZStack {
          RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray.opacity(0.3))
          HStack {
            Image(systemName: "magnifyingglass")
            VStack(spacing: 0) {
              TextField("", text: $text)
                .focused($isFocused, equals: .origin)
              
              Divider()
                .padding(.vertical)
              TextField("", text: $text2)
            }
          }
        }
        .padding(EdgeInsets(top: 50, leading: 10, bottom: 5, trailing: 10))
      }
      .frame(height: 150)
      .padding(.horizontal)
    }
    .offset(y: 120)
  }
  
  @ViewBuilder
  private var headScrols: some View {
    GeometryReader { geometry in
      LinearGradient(
        colors: [Color.blue, Color.blue.opacity(0.5), Color.gray.opacity(0.01)],
        startPoint: .top,
        endPoint: .bottom)
      .frame(height: max(200 + geometry.frame(in: .global).minY, 200))
      .offset(y: geometry.frame(in: .global).minY > 0 ? -geometry.frame(in: .global).minY : 0)
    }
    .frame(height: 200)
    
    Text("Тут покупают дешевые авиабилеты")
      .font(.title.bold())
      .foregroundColor(Color.white)
      .multilineTextAlignment(.center)
  }
}

struct InterestingContent: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color.blue.opacity(0.6), Color.yellow.opacity(0.3), Color.blue.opacity(0.2), Color.gray.opacity(0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
      VStack(alignment: .leading) {
        Text("Увидеть без визы")
          .font(.system(size: 20, design: .serif))
          .fontWeight(.bold)
          .foregroundColor(.black)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(0..<50) { item in
              VStack {
                Image(systemName: "photo.artframe")
                  .resizable()
                  .frame(width: 90, height: 90)
                Text("Name")
                Text("City")
                Text("\(Image(systemName: "airplane.circle.fill")) 14500руб")
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


#Preview {
  MainView()
}




