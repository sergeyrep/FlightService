//
//  HotelsView.swift
//  FlightService
//
//  Created by Сергей on 08.12.2025.
//
import SwiftUI

struct HotelsView: View {
  @State private var progress: CGFloat = 0
  @State private var searchBarOffset: CGFloat = 0
  
  var body: some View {
    GeometryReader { mainGeometry in
      ScrollView {
        VStack(spacing: 0) {
          // 1. Заголовок (фиксированной высоты)
          Color.blue
            .frame(height: 150)
            .overlay(
              Text("Заголовок")
                .font(.title)
                .foregroundColor(.white)
            )
          
          // 2. Анимируемая панель поиска
          SearchBar(progress: progress)
            .background(
              GeometryReader { geo in
                Color.clear
                  .onAppear {
                    // Получаем начальное положение
                    searchBarOffset = geo.frame(in: .global).minY
                  }
                  .onChange(of: geo.frame(in: .global).minY) { oldValue, newValue in
                    // Рассчитываем прогресс
                    let distanceFromTop = max(0, searchBarOffset - newValue)
                    let newProgress = min(distanceFromTop / 100, 1.0)
                    
                    withAnimation(.spring(response: 0.3)) {
                      progress = newProgress
                    }
                  }
              }
            )
            .padding(.top, -50) // Перекрываем заголовок
            .padding(.horizontal)
            .padding(.bottom, 20)
          
          // 3. Контент для скролла
          VStack(spacing: 10) {
            ForEach(0..<50) { i in
              Text("Элемент \(i)")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal)
            }
          }
        }
      }
      .background(Color.gray.opacity(0.1))
      .ignoresSafeArea()
      
      // Индикатор прогресса (для отладки)
      VStack {
        Text("Progress: \(progress, specifier: "%.2f")")
          .padding()
          .background(Color.white)
          .cornerRadius(10)
          .shadow(radius: 5)
        Spacer()
      }
      .padding(.top, 50)
    }
  }
}

struct SearchBar: View {
  let progress: CGFloat
  
  var body: some View {
    ZStack {
      // Фон с анимацией
      RoundedRectangle(cornerRadius: 20 * (1 - progress * 0.4))
        .fill(Color.white)
        .frame(height: 150 * (1 - progress * 0.67))
        .shadow(
          color: .black.opacity(0.1 + progress * 0.1),
          radius: 5 + progress * 3,
          x: 0,
          y: 2 + progress * 3
        )
      
      // Контент
      if progress < 0.7 {
        // Развернутый вид
        VStack(spacing: 0) {
          TextField("Откуда", text: .constant(""))
            .padding(.vertical, 16)
          
          Divider()
            .opacity(1.0 - progress * 2)
          
          TextField("Куда", text: .constant(""))
            .padding(.vertical, 16)
            .opacity(1 - progress)
        }
        .padding(.horizontal)
        .opacity(1.0 - progress * 0.5)
      } else {
        // Компактный вид
        HStack {
          Text("Москва → СПб")
            .font(.subheadline)
          Spacer()
          Image(systemName: "chevron.right")
        }
        .padding(.horizontal)
        .opacity((progress - 0.7) * 3.3)
      }
    }
    .animation(.spring(response: 0.3), value: progress)
  }
}

#Preview {
  HotelsView()
}
