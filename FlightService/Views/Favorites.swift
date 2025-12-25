//
//  Favorites.swift
//  FlightService
//
//  Created by Сергей on 08.12.2025.
//

import SwiftUI

struct Favorites: View {
  @State var isConected = false
  var body: some View {
    VStack {
      
      HStack {
        
        Button {
          
        } label: {
          Image(systemName: "circle.grid.cross")
            .font(.title)
            .padding(12)
            .background {
              RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black.opacity(0.4), lineWidth: 1)
            }
            .foregroundStyle(Color.black)
        }
        
        Spacer()
        
        Button {
          
        } label: {
          Image(systemName: "slider.horizontal.3")
            .font(.title)
            .padding(12)
            .background {
              RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black.opacity(0.4), lineWidth: 1)
            }
            .foregroundStyle(Color.black)
        }
      }
      .overlay(
        Text(getTitleAtribute())
          .foregroundColor(.black.opacity(0.8))
      )
      .foregroundColor(.white)
      
      powerButton()
      globeAtribute()
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(
      ZStack {
        LinearGradient(colors: [.purple, .pink, .orange], startPoint: .top, endPoint: .bottom)
      }
        .ignoresSafeArea()
    )
  }
  
  func getTitleAtribute() -> AttributedString {
    var str = AttributedString("SuperVPN")
    
    if let range = str.range(of: "VPN") {
      str[range].font = .system(size: 24, weight: .black)
    }
    
    if let range = str.range(of: "Super") {
      str[range].font = .system(size: 24, weight: .light)
    }
    return str
  }
  
  @ViewBuilder
  func powerButton() -> some View {
    Button {
      withAnimation {
        isConected.toggle()
      }
    } label: {
      ZStack {
        Image(systemName: "power")
          .font(.system(size: 65, weight: .bold))
          .foregroundColor(isConected ? .white : .black)
          .scaleEffect(isConected ? 0.7 : 1)
          .offset(y: isConected ? -30 : 0)
        
        
        Text("Disconect")
          .fontWeight(.bold)
          .foregroundColor(.white)
          .offset(y: 20)
          .opacity(isConected ? 1 : 0)
      }
      .frame(maxWidth: 190, maxHeight: 190)
      .background(
        ZStack {
          Circle()
            .trim(from: isConected ? 0 : 0.3, to: isConected ? 1 : 0.5)
            .stroke(
              LinearGradient(colors: [.blue, .green, .yellow, .red], startPoint: .leading, endPoint: .trailing),
              style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: .black, radius: 5, x: 1, y: -4)
          
          Circle()
            .trim(from: isConected ? 0 : 0.3, to: isConected ? 1 : 0.49)
            .stroke(
              LinearGradient(colors: [.blue, .green, .yellow, .red], startPoint: .leading, endPoint: .trailing),
              style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: .gray, radius: 5, x: 1, y: -4)
            .rotationEffect(.init(degrees: 180))
          
          Circle()
            .stroke(
              Color.blue
                .opacity(0.05),
              lineWidth: 11
            )
            .shadow(color: .black.opacity(isConected ? 1 : 0), radius: 5, x: 1, y: -4)
        }
      )
    }
    .padding(.top, 100)
  }
  
  func globeAtribute() -> some View {
    ZStack {
      Image(systemName: "globe")
        .font(.system(size: isConected ? 100 : 350))
        .foregroundStyle(isConected ? .black : .white)
      
      Circle()
      
      //.trim(from: isConected ? 1 : 0.4, to: isConected ? 1 : 0.4)
        .stroke(
          LinearGradient(colors: [.black, .white, .blue], startPoint: .leading, endPoint: .trailing),
          style: StrokeStyle(lineWidth: 10)
        )
        .rotationEffect(.init(degrees: 180))
      
    }
    .frame(maxWidth: 350, maxHeight: 350)
    .padding(.top, 20)
  }
}

#Preview {
  Favorites()
}
