//
//  ImpressionsView.swift
//  FlightService
//
//  Created by Сергей on 08.12.2025.
//

import SwiftUI

struct ImpressionsView: View {
  var body: some View {
    Text("Hello, world!")
  }
}

struct FlightSearchView: View {
  @State private var searchText = ""
  @State private var showFullSearch = true
  @State private var offset: CGFloat = 0
  
  var body: some View {
    NavigationView {
      ScrollView {
        GeometryReader { geometry in
          Color.clear
            .preference(
              key: ScrollOffsetKey.self,
              value: geometry.frame(in: .named("scroll")).minY
            )
        }
        .frame(height: 0)
        
        // Контент под поиском
        VStack(spacing: 20) {
          ForEach(0..<30) { i in
            FlightCardView()
              .padding(.horizontal)
          }
        }
        .padding(.top, showFullSearch ? 320 : 100)
      }
      .coordinateSpace(name: "scroll")
      .onPreferenceChange(ScrollOffsetKey.self) { value in
        handleScroll(offset: value)
      }
      .overlay(
        SearchBarView(showFullSearch: $showFullSearch,
                      searchText: $searchText,
                      offset: $offset)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showFullSearch),
        alignment: .top
      )
      .navigationBarHidden(false)
      .ignoresSafeArea(.all, edges: .top)
    }
  }
  
  private func handleScroll(offset: CGFloat) {
    let threshold: CGFloat = -100
    
    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
      if offset < threshold && showFullSearch {
        self.showFullSearch = false
        self.offset = offset
      } else if offset > -50 && !showFullSearch {
        self.showFullSearch = true
        self.offset = offset
      }
    }
  }
}

// Ключ для отслеживания скролла
struct ScrollOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
// Карточка полета для контента
struct FlightCardView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        VStack(alignment: .leading) {
          Text("Москва → Стамбул")
            .font(.headline)
          Text("17 дек, 1 пассажир")
            .font(.caption)
            .foregroundColor(.gray)
        }
        
        Spacer()
        
        Text("12 450 ₽")
          .font(.title3)
          .fontWeight(.bold)
          .foregroundColor(.blue)
      }
      
      HStack {
        TagView(text: "Прямой", color: .green)
        TagView(text: "Багаж включен", color: .blue)
        Spacer()
        Text("от 5:30")
          .font(.caption)
      }
      
      Divider()
      
      HStack {
        Image(systemName: "airplane")
          .foregroundColor(.gray)
        Text("Turkish Airlines")
          .font(.caption)
        Spacer()
        Image(systemName: "star.fill")
          .foregroundColor(.yellow)
        Text("8.5")
          .font(.caption)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
  }
}

struct TagView: View {
  let text: String
  let color: Color
  
  var body: some View {
    Text(text)
      .font(.caption2)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(color.opacity(0.1))
      .foregroundColor(color)
      .cornerRadius(6)
  }
}

struct SearchBarView: View {
  @Binding var showFullSearch: Bool
  @Binding var searchText: String
  @Binding var offset: CGFloat
  
  var body: some View {
    VStack(spacing: 0) {
      // Верхний бар с безопасной зоной
      Color.white
        .frame(height: 50)
        .overlay(
          HStack {
            if !showFullSearch {
              CompactSearchView(searchText: $searchText)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
          }
        )
      
      // Основная панель поиска
      if showFullSearch {
        FullSearchView(searchText: $searchText)
          .transition(.move(edge: .top).combined(with: .opacity))
      }
    }
    .background(
      Color.white
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .edgesIgnoringSafeArea(.top)
    )
    .offset(y: showFullSearch ? max(offset, 0) : 0)
  }
}

// Полная панель поиска (как в Авиасейлс)
struct FullSearchView: View {
  @Binding var searchText: String
  
  var body: some View {
    VStack(spacing: 20) {
      // Заголовок
      HStack {
        Text("Поиск билетов")
          .font(.title2)
          .fontWeight(.semibold)
        Spacer()
        Button(action: {}) {
          Image(systemName: "slider.horizontal.3")
            .font(.title3)
        }
      }
      .padding(.horizontal)
      
      // Поля поиска
      VStack(spacing: 15) {
        // Откуда
        SearchFields(
          icon: "airplane.departure",
          title: "Откуда",
          placeholder: "Город вылета",
          text: .constant("Москва")
        )
        
        // Куда
        SearchFields(
          icon: "airplane.arrival",
          title: "Куда",
          placeholder: "Куда лететь?",
          text: $searchText
        )
        
        // Даты
        HStack(spacing: 15) {
          SearchFields(
            icon: "calendar",
            title: "Туда",
            placeholder: "Дата вылета",
            text: .constant("17 дек")
          )
          
          SearchFields(
            icon: "calendar",
            title: "Обратно",
            placeholder: "Дата возврата",
            text: .constant("24 дек")
          )
        }
        
        // Пассажиры
        SearchFields(
          icon: "person.2",
          title: "Пассажиры",
          placeholder: "1 взрослый",
          text: .constant("")
        )
      }
      .padding(.horizontal)
      
      // Кнопка поиска
      Button(action: {}) {
        HStack {
          Image(systemName: "magnifyingglass")
          Text("Найти билеты")
            .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
      }
      .padding(.horizontal)
      .padding(.top, 10)
    }
    .padding(.top, 50)
    .padding(.bottom, 30)
    .background(Color.white)
  }
}

// Компактный поиск (после скролла)
struct CompactSearchView: View {
  @Binding var searchText: String
  
  var body: some View {
    HStack(spacing: 12) {
      // Иконка поиска
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray)
      
      // Поле ввода
      TextField("Куда лететь?", text: $searchText)
        .font(.body)
      
      // Кнопки справа
      HStack(spacing: 15) {
        Button(action: {}) {
          Image(systemName: "slider.horizontal.3")
            .font(.callout)
        }
        
        Button(action: {}) {
          Image(systemName: "map")
            .font(.callout)
        }
      }
    }
    .padding(.horizontal, 15)
    .padding(.vertical, 10)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(.systemGray6))
    )
    .padding(.horizontal)
  }
}

// Компонент поля поиска
struct SearchFields: View {
  let icon: String
  let title: String
  let placeholder: String
  @Binding var text: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Image(systemName: icon)
          .foregroundColor(.blue)
          .frame(width: 20)
        
        Text(title)
          .font(.caption)
          .foregroundColor(.gray)
        
        Spacer()
      }
      
      if text.isEmpty {
        Text(placeholder)
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: .leading)
      } else {
        Text(text)
          .foregroundColor(.primary)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color(.systemGray4), lineWidth: 1)
    )
    .contentShape(Rectangle())
    .onTapGesture {
      // Действие при тапе на поле
    }
  }
}

#Preview {
  FlightSearchView()
}
