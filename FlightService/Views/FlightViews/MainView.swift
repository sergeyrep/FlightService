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
  
  @State private var progress: CGFloat = 0
  @State private var searchBarOffset: CGFloat = 0
  
  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        headScrols
        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
          Section(header: searchBar
            .background(
              GeometryReader { geometry in
                Color.clear
                  .onAppear {
                    searchBarOffset = geometry.frame(in: .global).minY
                  }
                  .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
                    let distanceFromTop = max(0, searchBarOffset - newValue)
                    let newProgress = min(distanceFromTop / 100, 1.0)
                    
                    withAnimation(.spring(response: 0.3)) {
                      progress = newProgress
                    }
                  }
              }
            )
          ) {
            InterestingContent()
            SalesFlight()
            WeekendFlight()
            ForEach(0..<50) { circle in
              Circle()
            }
          }
        }
      }
    }
    .background(.gray.opacity(0.3))
    .ignoresSafeArea()
    .onPreferenceChange(ScrollOffsetKey.self) { value in
      print("Offset = \(value)")
      progress = value
    }
    .sheet(isPresented: $showFlight) {
      FlightView(viewModel: .init())
    }
    .onChange(of: isFocused) { _, newValue in
      if newValue == .origin || newValue == .departure {
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
  
  @ViewBuilder
  private var searchBar: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.white)
        .shadow(
          color: .black.opacity(interpolate(from: 0.3, to: 0.1, progress: progress)),
          radius: interpolate(from: 4, to: 9, progress: progress),
          x: 0,
          y: interpolate(from: 2, to: 4, progress: progress)
        )
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.gray.opacity(0.3))
        HStack {
          if progress < 0.8 {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
            .font(.system(size: 20))
            .padding(.leading)
            VStack(spacing: 0) {
              TextField("", text: $text)
                .focused($isFocused, equals: .origin)
                .opacity(1.0 - progress)
              Divider()
                .padding(.vertical)
                .opacity(1.0 - progress)
              TextField("", text: $text2)
            }
            .opacity(1.0 - progress * 0.5)
            .frame(height: 50 * (1.75 - progress))
          } else {
            HStack {
              Image(systemName: "magnifyingglass")
              TextField("", text: $text2)
                .focused($isFocused, equals: .departure)
                .frame(height: 50)
            }
              .opacity((progress - 0.7) * 3.3)
          }
        }
      }
      .padding(EdgeInsets(top: 60, leading: 10 * (1.5 - progress), bottom: 5 * (1 - progress), trailing: 10 * (1.5 - progress)))
    }
    .padding(.horizontal, 20 - (20 * progress))
    .animation(.spring(response: 0.3), value: progress)
  }
  
  
  @ViewBuilder
  private var headScrols: some View {
    GeometryReader { geometry in
      let offset = geometry.frame(in: .global).minY
      let isScrolled = offset > 0
      let headerHeight = 150 + (isScrolled ? offset : 0)
      ZStack {
        LinearGradient(
          colors: [Color.blue, Color.blue.opacity(0.5), Color.gray.opacity(0.01)],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: headerHeight)
        .offset(y: isScrolled ? -offset : 0)
        
        VStack {
          Spacer()
          Text("Тут покупают дешевые авиабилеты")
            .font(.title.bold())
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
      }
    }
    .frame(height: 150)
  }
  
  func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
    return from + (to - from) * progress
  }
}

struct SearchBarOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

#Preview {
  MainView()
}


//#Preview {
//  TransformingView()
//}

//struct TransformingView: View {
//  @State private var progress: CGFloat = 0
//
//  var body: some View {
//    ZStack {
//      // Анимируемый контейнер
//      RoundedRectangle(cornerRadius: 20 * (1 - progress * 0.4))
//        .fill(Color.blue)
//        .frame(height: 150 * (1 - progress * 0.67))
//
//      // Контент
//      if progress < 0.7 {
//        VStack {
//          Text("Поле 1")
//          Divider()//.opacity(1 - progress * 2)
//          Text("Поле 2").opacity(1 - progress)
//        }
//      } else {
//        Text("Объединенный текст")
//      }
//    }
//    .animation(.spring(), value: progress)
//    .gesture(
//      DragGesture()
//        .onChanged { value in
//          progress = min(max(-value.translation.height / 100, 0), 1)
//        }
//    )
//  }
//}
