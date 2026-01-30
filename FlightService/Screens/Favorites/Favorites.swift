import SwiftUI

struct Favorites: View {
  @State private var favoriteFlights: [Flight] = mockFlights
  @State private var favoriteCities: [FavoriteCity] = mockCities
  @State private var selectedSegment = 0
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // Сегментированный контрол
        Picker("", selection: $selectedSegment) {
          Text("Рейсы").tag(0)
          Text("Города").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        
        if selectedSegment == 0 {
          favoriteFlightsView
        } else {
          favoriteCitiesView
        }
      }
      .navigationTitle("Избранное")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          editButton
        }
      }
    }
  }
  
  // MARK: - Избранные рейсы
  private var favoriteFlightsView: some View {
    Group {
      if favoriteFlights.isEmpty {
        emptyStateView(
          icon: "airplane",
          title: "Нет избранных рейсов",
          message: "Сохраняйте понравившиеся рейсы, нажав на звездочку"
        )
      } else {
        ScrollView {
          LazyVStack(spacing: 12) {
            ForEach(favoriteFlights) { flight in
              FavoriteFlightCard(flight: flight)
                .swipeActions(edge: .trailing) {
                  Button(role: .destructive) {
                    removeFlight(flight)
                  } label: {
                    Label("Удалить", systemImage: "trash")
                  }
                }
            }
          }
          .padding()
        }
      }
    }
  }
  
  // MARK: - Избранные города
  private var favoriteCitiesView: some View {
    Group {
      if favoriteCities.isEmpty {
        emptyStateView(
          icon: "building.2",
          title: "Нет избранных городов",
          message: "Добавляйте города для быстрого доступа к билетам"
        )
      } else {
        ScrollView {
          LazyVGrid(
            columns: [
              GridItem(.flexible()),
              GridItem(.flexible())
            ],
            spacing: 16
          ) {
            ForEach(favoriteCities) { city in
              FavoriteCityCard(city: city)
                .contextMenu {
                  Button(role: .destructive) {
                    removeCity(city)
                  } label: {
                    Label("Удалить", systemImage: "trash")
                  }
                }
            }
          }
          .padding()
        }
      }
    }
  }
  
  // MARK: - Пустое состояние
  private func emptyStateView(icon: String, title: String, message: String) -> some View {
    VStack(spacing: 16) {
      Spacer()
      
      Image(systemName: icon)
        .font(.system(size: 60))
        .foregroundColor(.gray.opacity(0.3))
      
      VStack(spacing: 8) {
        Text(title)
          .font(.headline)
          .foregroundColor(.primary)
        
        Text(message)
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)
      }
      
      Button(action: {
        // Переход к поиску
      }) {
        HStack {
          Image(systemName: "magnifyingglass")
          Text("Найти рейсы")
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color.blue)
        .cornerRadius(10)
      }
      .padding(.top, 8)
      
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  // MARK: - Кнопка редактирования
  private var editButton: some View {
    Button(action: {
      // Режим редактирования
    }) {
      Image(systemName: "ellipsis")
        .foregroundColor(.blue)
    }
  }
  
  // MARK: - Методы
  private func removeFlight(_ flight: Flight) {
    withAnimation {
      favoriteFlights.removeAll { $0.id == flight.id }
    }
  }
  
  private func removeCity(_ city: FavoriteCity) {
    withAnimation {
      favoriteCities.removeAll { $0.id == city.id }
    }
  }
}

// MARK: - Карточка избранного рейса
struct FavoriteFlightCard: View {
  let flight: Flight
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Верхняя часть
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(flight.airline)
            .font(.headline)
          
          Text("\(flight.origin) → \(flight.destination)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        
        Spacer()
        
        Text("\(flight.price) \(flight.currency)")
          .font(.title3)
          .fontWeight(.bold)
          .foregroundColor(.blue)
      }
      
      Divider()
        .padding(.horizontal, -16)
      
      // Нижняя часть - даты
      HStack {
        VStack(alignment: .leading, spacing: 2) {
          Text("Вылет")
            .font(.caption2)
            .foregroundColor(.secondary)
          
          Text(formatDate(flight.departureTime))
            .font(.subheadline)
            .fontWeight(.medium)
        }
        
        Spacer()
        
        if flight.isReturn, let returnTime = flight.returnTime {
          VStack(alignment: .trailing, spacing: 2) {
            Text("Возврат")
              .font(.caption2)
              .foregroundColor(.secondary)
            
            Text(formatDate(returnTime))
              .font(.subheadline)
              .fontWeight(.medium)
          }
        }
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
    )
  }
  
  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }
}

// MARK: - Карточка избранного города
struct FavoriteCityCard: View {
  let city: FavoriteCity
  
  var body: some View {
    VStack(spacing: 12) {
      // Изображение города
      AsyncImage(url: URL(string: city.imageUrl)) { phase in
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
      .frame(height: 120)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      
      // Информация
      VStack(spacing: 4) {
        Text(city.name)
          .font(.headline)
          .foregroundColor(.primary)
        
        Text(city.country)
          .font(.caption)
          .foregroundColor(.secondary)
        
        HStack(spacing: 4) {
          Image(systemName: "airplane")
            .font(.caption2)
            .foregroundColor(.blue)
          
          Text("от \(city.minPrice) ₽")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
        }
        .padding(.top, 4)
      }
      
      Spacer(minLength: 0)
    }
    .padding(12)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    )
  }
}

// MARK: - Модели данных
struct FavoriteCity: Identifiable {
  let id = UUID()
  let name: String
  let country: String
  let imageUrl: String
  let minPrice: Int
}

// MARK: - Моки данных
private let mockFlights: [Flight] = [
  Flight(
    airline: "Аэрофлот",
    flightNumber: "SU 1234",
    departureTime: Date(),
    arrivalTime: Calendar.current.date(byAdding: .hour, value: 5, to: Date()),
    price: 14500,
    origin: "Москва (SVO)",
    destination: "Санкт-Петербург (LED)",
    currency: "RUB",
    isReturn: true,
    returnTime: Calendar.current.date(byAdding: .day, value: 7, to: Date())
  ),
  Flight(
    airline: "S7 Airlines",
    flightNumber: "S7 5678",
    departureTime: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
    arrivalTime: Calendar.current.date(byAdding: .day, value: 3, to: Calendar.current.date(byAdding: .hour, value: 4, to: Date())!)!,
    price: 8900,
    origin: "Новосибирск (OVB)",
    destination: "Москва (DME)",
    currency: "RUB",
    isReturn: false,
    returnTime: nil
  )
]

private let mockCities: [FavoriteCity] = [
  FavoriteCity(
    name: "Москва",
    country: "Россия",
    imageUrl: "https://photo.hotellook.com/static/cities/960x720/MOW.jpg",
    minPrice: 4500
  ),
  FavoriteCity(
    name: "Санкт-Петербург",
    country: "Россия",
    imageUrl: "https://photo.hotellook.com/static/cities/960x720/LED.jpg",
    minPrice: 5200
  ),
  FavoriteCity(
    name: "Сочи",
    country: "Россия",
    imageUrl: "https://photo.hotellook.com/static/cities/960x720/AER.jpg",
    minPrice: 6800
  ),
  FavoriteCity(
    name: "Казань",
    country: "Россия",
    imageUrl: "https://photo.hotellook.com/static/cities/960x720/KZN.jpg",
    minPrice: 3900
  )
]

// MARK: - Preview
struct Favorites_Previews: PreviewProvider {
  static var previews: some View {
    Favorites()
  }
}
