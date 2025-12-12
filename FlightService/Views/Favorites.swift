//
//  Favorites.swift
//  FlightService
//
//  Created by Сергей on 08.12.2025.
//

import SwiftUI

struct Favorites: View {
  @State private var scrollOffset: CGFloat = 0
  @State private var isScrolling = false
  
  var body: some View {
    VStack {
      // Индикатор положения скролла
      VStack {
        Text("Смещение: \(Int(scrollOffset))")
          .font(.headline)
        Text("Скроллинг: \(isScrolling ? "Да" : "Нет")")
          .font(.caption)
        
        // Визуальный индикатор
        Rectangle()
          .frame(height: 4)
          .foregroundColor(.blue)
          .frame(width: 200)
          .overlay(
            Circle()
              .frame(width: 20, height: 20)
              .foregroundColor(.blue)
              .offset(x: CGFloat(min(max(scrollOffset / 10, -100), 100)))
          )
      }
      .padding()
      
      // Основной скролл-вью
      ScrollView {
        GeometryReader { proxy in
          Color.clear
            .preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        
        VStack(spacing: 20) {
          ForEach(1...50, id: \.self) { index in
            RoundedRectangle(cornerRadius: 10)
              .frame(height: 80)
              .foregroundColor(.blue.opacity(0.3))
              .overlay(
                Text("Элемент \(index)")
                  .foregroundColor(.white)
                  .font(.headline)
              )
              .shadow(radius: 2)
          }
        }
        .padding()
      }
      .coordinateSpace(name: "scroll")
      .onPreferenceChange(ScrollOffsetKey.self) { value in
        scrollOffset = value
      }
      
      // Альтернативный способ с GeometryReader
      ScrollView {
        LazyVStack {
          ForEach(1...30, id: \.self) { index in
            Text("Строка \(index)")
              .frame(maxWidth: .infinity)
              .frame(height: 60)
              .background(index % 2 == 0 ? Color.gray.opacity(0.2) : Color.white)
              .cornerRadius(8)
              .padding(.horizontal)
          }
        }
        .background(
          GeometryReader { proxy in
            Color.clear
              .onChange(of: proxy.frame(in: .global).minY) { oldValue, newValue in
                isScrolling = true
                // Сброс флага через 0.1 секунду
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  isScrolling = false
                }
              }
          }
        )
      }
    }
  }
}


// Более простой вариант с отслеживанием видимых элементов
struct SimpleScrollTracker: View {
  @State private var visibleRange: ClosedRange<Int> = 0...0
  
  var body: some View {
    VStack {
      Text("Видимые элементы: \(visibleRange.lowerBound)-\(visibleRange.upperBound)")
        .padding()
      
      ScrollView {
        LazyVStack {
          ForEach(1...100, id: \.self) { index in
            Text("Item \(index)")
              .frame(height: 50)
              .frame(maxWidth: .infinity)
              .background(
                GeometryReader { geo in
                  Color.clear
                    .onAppear {
                      if geo.frame(in: .global).minY > 0 &&
                          geo.frame(in: .global).minY < UIScreen.main.bounds.height {
                        visibleRange = min(index, visibleRange.lowerBound)...max(index, visibleRange.upperBound)
                      }
                    }
                }
              )
          }
        }
      }
    }
  }
}

#Preview {
  Favorites()
}
