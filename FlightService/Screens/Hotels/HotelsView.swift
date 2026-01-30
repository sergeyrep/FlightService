import SwiftUI

struct HotelsView: View {
  @State private var selectedCity = "Москва"
  @State private var checkInDate = Date()
  @State private var checkOutDate = Date().addingTimeInterval(86400 * 3) // +3 дня
  @State private var guestsCount = 2
  @State private var roomsCount = 1
  @State private var priceRange: ClosedRange<Double> = 1000...10000
  @State private var selectedStars: Set<Int> = [3, 4, 5]
  @State private var showingFilters = false
  @State private var searchText = ""
  
  let cities = ["Москва", "Санкт-Петербург", "Сочи", "Казань", "Екатеринбург", "Новосибирск"]
  let hotels = mockHotels
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // Поисковая панель
        searchPanel
        
        // Результаты поиска
        if hotels.isEmpty {
          emptyStateView
        } else {
          hotelsListView
        }
      }
      .navigationTitle("Отели")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          filterButton
        }
      }
      .sheet(isPresented: $showingFilters) {
        filtersView
      }
    }
  }
  
  // MARK: - Поисковая панель
  private var searchPanel: some View {
    VStack(spacing: 12) {
      // Город
      HStack {
        Image(systemName: "mappin.circle.fill")
          .foregroundColor(.blue)
        
        Menu {
          ForEach(cities, id: \.self) { city in
            Button(city) {
              selectedCity = city
            }
          }
        } label: {
          HStack {
            Text(selectedCity)
              .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.down")
              .font(.caption)
          }
          .foregroundColor(.primary)
        }
      }
      .padding()
      .background(Color(.systemGray6))
      .cornerRadius(12)
      
      // Даты
      HStack(spacing: 12) {
        DateSelectionView(
          title: "Заезд",
          date: $checkInDate,
          icon: "calendar"
        )
        
        DateSelectionView(
          title: "Выезд",
          date: $checkOutDate,
          icon: "calendar.badge.clock"
        )
      }
      
      // Гости и комнаты
      HStack {
        GuestCounterView(
          icon: "person.2.fill",
          title: "Гости",
          count: $guestsCount
        )
        
        Spacer()
        
        GuestCounterView(
          icon: "bed.double.fill",
          title: "Комнаты",
          count: $roomsCount
        )
      }
      
      // Кнопка поиска
      Button(action: {
        // Поиск отелей
      }) {
        HStack {
          Image(systemName: "magnifyingglass")
          Text("Найти отели")
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.blue)
        .cornerRadius(12)
      }
    }
    .padding()
    .background(Color.white)
    .shadow(color: .black.opacity(0.05), radius: 10, y: 2)
  }
  
  // MARK: - Список отелей
  private var hotelsListView: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(hotels) { hotel in
          HotelCard(hotel: hotel)
            .padding(.horizontal)
        }
      }
      .padding(.vertical)
    }
    .background(Color(.systemGroupedBackground))
  }
  
  // MARK: - Пустое состояние
  private var emptyStateView: some View {
    VStack(spacing: 20) {
      Spacer()
      
      Image(systemName: "building.2")
        .font(.system(size: 60))
        .foregroundColor(.gray.opacity(0.3))
      
      VStack(spacing: 8) {
        Text("Отели не найдены")
          .font(.headline)
        
        Text("Попробуйте изменить параметры поиска")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 40)
      }
      
      Button("Сбросить фильтры") {
        resetFilters()
      }
      .font(.subheadline)
      .foregroundColor(.blue)
      .padding(.top, 8)
      
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
  }
  
  // MARK: - Кнопка фильтров
  private var filterButton: some View {
    Button(action: {
      showingFilters = true
    }) {
      Image(systemName: "slider.horizontal.3")
        .foregroundColor(.blue)
        .overlay(
          Circle()
            .fill(Color.red)
            .frame(width: 8, height: 8)
            .offset(x: 5, y: -5)
            .opacity(hasActiveFilters ? 1 : 0)
        )
    }
  }
  
  private var hasActiveFilters: Bool {
    priceRange.lowerBound > 1000 || priceRange.upperBound < 10000 || selectedStars.count < 5
  }
  
  // MARK: - Фильтры
  private var filtersView: some View {
    NavigationView {
      List {
        // Диапазон цен
        Section("Цена за ночь") {
          VStack(spacing: 16) {
            HStack {
              Text("\(Int(priceRange.lowerBound)) ₽")
                .font(.headline)
              
              Spacer()
              
              Text("\(Int(priceRange.upperBound)) ₽")
                .font(.headline)
            }
           // value: $priceRange, in: 5000...200000, step: 500.0
            //Slider(value: <#T##Binding<BinaryFloatingPoint>#>, label: <#T##() -> View#>)
          }
          .padding(.vertical, 8)
        }
        
        // Звезды
        Section("Категория отеля") {
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
            ForEach(1...5, id: \.self) { stars in
              StarFilterButton(
                stars: stars,
                isSelected: selectedStars.contains(stars)
              ) {
                if selectedStars.contains(stars) {
                  selectedStars.remove(stars)
                } else {
                  selectedStars.insert(stars)
                }
              }
            }
          }
          .padding(.vertical, 8)
        }
        
        // Типы отелей
        Section("Тип размещения") {
          let types = ["Отель", "Апартаменты", "Хостел", "Гостевой дом", "Вилла"]
          ForEach(types, id: \.self) { type in
            HStack {
              Text(type)
              Spacer()
              Image(systemName: "checkmark")
                .foregroundColor(.blue)
                .opacity(type == "Отель" ? 1 : 0)
            }
            .contentShape(Rectangle())
            .onTapGesture {
              // Выбор типа
            }
          }
        }
        
        // Кнопки
        Section {
          HStack(spacing: 12) {
            Button("Сбросить") {
              resetFilters()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Button("Применить") {
              showingFilters = false
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
          }
        }
        .listRowBackground(Color.clear)
      }
      .navigationTitle("Фильтры")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Готово") {
            showingFilters = false
          }
        }
      }
    }
  }
  
  // MARK: - Методы
  private func resetFilters() {
    priceRange = 1000...10000
    selectedStars = [3, 4, 5]
  }
}

// MARK: - Компоненты
struct DateSelectionView: View {
  let title: String
  @Binding var date: Date
  let icon: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Image(systemName: icon)
          .foregroundColor(.blue)
        
        Text(title)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      DatePicker("", selection: $date, displayedComponents: .date)
        .labelsHidden()
        .accentColor(.blue)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

struct GuestCounterView: View {
  let icon: String
  let title: String
  @Binding var count: Int
  
  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: icon)
        .foregroundColor(.blue)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.caption)
          .foregroundColor(.secondary)
        
        HStack(spacing: 16) {
          Button(action: {
            if count > 1 { count -= 1 }
          }) {
            Image(systemName: "minus.circle.fill")
              .foregroundColor(.gray)
          }
          
          Text("\(count)")
            .font(.headline)
            .frame(minWidth: 30)
          
          Button(action: {
            if count < 10 { count += 1 }
          }) {
            Image(systemName: "plus.circle.fill")
              .foregroundColor(.blue)
          }
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

struct HotelCard: View {
  let hotel: Hotel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Изображение
      ZStack(alignment: .topTrailing) {
        AsyncImage(url: URL(string: hotel.imageUrl)) { phase in
          switch phase {
          case .empty:
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.gray.opacity(0.2))
              .overlay(ProgressView())
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          case .failure:
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.gray.opacity(0.2))
              .overlay(
                Image(systemName: "photo")
                  .foregroundColor(.gray)
              )
          @unknown default:
            EmptyView()
          }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        // Избранное
        Button(action: {
          // Добавить в избранное
        }) {
          Image(systemName: "heart")
            .font(.title3)
            .foregroundColor(.white)
            .padding(8)
            .background(Circle().fill(Color.black.opacity(0.3)))
        }
        .padding(12)
      }
      
      // Информация
      VStack(alignment: .leading, spacing: 8) {
        // Название и рейтинг
        HStack {
          Text(hotel.name)
            .font(.headline)
            .lineLimit(1)
          
          Spacer()
          
          HStack(spacing: 4) {
            Image(systemName: "star.fill")
              .font(.caption)
              .foregroundColor(.yellow)
            
            Text(String(format: "%.1f", hotel.rating))
              .font(.subheadline)
              .fontWeight(.semibold)
          }
        }
        
        // Местоположение
        HStack(spacing: 6) {
          Image(systemName: "mappin.circle.fill")
            .font(.caption)
            .foregroundColor(.gray)
          
          Text(hotel.location)
            .font(.caption)
            .foregroundColor(.secondary)
            .lineLimit(1)
        }
        
        Divider()
        
        // Цена и кнопка
        HStack {
          VStack(alignment: .leading, spacing: 2) {
            Text("\(hotel.pricePerNight) ₽")
              .font(.title2)
              .fontWeight(.bold)
              .foregroundColor(.blue)
            
            Text("за ночь")
              .font(.caption)
              .foregroundColor(.secondary)
          }
          
          Spacer()
          
          Button("Забронировать") {
            // Бронирование
          }
          .font(.subheadline)
          .foregroundColor(.white)
          .padding(.horizontal, 20)
          .padding(.vertical, 10)
          .background(Color.blue)
          .cornerRadius(8)
        }
      }
      .padding()
    }
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
  }
}

struct StarFilterButton: View {
  let stars: Int
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 2) {
        ForEach(0..<stars, id: \.self) { _ in
          Image(systemName: "star.fill")
            .font(.caption2)
        }
      }
      .foregroundColor(isSelected ? .yellow : .gray)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity)
      .background(isSelected ? Color.yellow.opacity(0.1) : Color.clear)
      .cornerRadius(8)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(isSelected ? Color.yellow : Color.gray.opacity(0.3), lineWidth: 1)
      )
    }
  }
}

// MARK: - Модели данных
struct Hotel: Identifiable {
  let id = UUID()
  let name: String
  let location: String
  let rating: Double
  let pricePerNight: Int
  let imageUrl: String
  let stars: Int
}

// MARK: - Моки данных
private let mockHotels: [Hotel] = [
  Hotel(
    name: "Four Seasons Hotel Moscow",
    location: "Охотный ряд, Москва",
    rating: 4.8,
    pricePerNight: 25000,
    imageUrl: "https://images.unsplash.com/photo-1566073771259-6a8506099945",
    stars: 5
  ),
  Hotel(
    name: "Hotel Metropol",
    location: "Театральный проезд, Москва",
    rating: 4.6,
    pricePerNight: 18000,
    imageUrl: "https://images.unsplash.com/photo-1584132967334-10e028bd69f7",
    stars: 5
  ),
  Hotel(
    name: "Ararat Park Hyatt",
    location: "Неглинная улица, Москва",
    rating: 4.7,
    pricePerNight: 22000,
    imageUrl: "https://images.unsplash.com/photo-1611892440504-42a792e24d32",
    stars: 5
  ),
  Hotel(
    name: "Golden Ring Hotel",
    location: "Смоленская улица, Москва",
    rating: 4.4,
    pricePerNight: 12000,
    imageUrl: "https://images.unsplash.com/photo-1590490360182-c33d57733427",
    stars: 4
  ),
  Hotel(
    name: "Hilton Moscow Leningradskaya",
    location: "Каланчёвская улица, Москва",
    rating: 4.5,
    pricePerNight: 15000,
    imageUrl: "https://images.unsplash.com/photo-1564501049418-3c27787d01e8",
    stars: 5
  )
]

// MARK: - Preview
struct HotelsView_Previews: PreviewProvider {
  static var previews: some View {
    HotelsView()
  }
}
