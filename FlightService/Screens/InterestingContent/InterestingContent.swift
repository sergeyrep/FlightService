import SwiftUI

struct InterestingContent: View {
  let fotosCities = [
    "https://photo.hotellook.com/static/cities/960x720/MOW.jpg",
    "https://photo.hotellook.com/static/cities/960x720/KZN.jpg",
    "https://photo.hotellook.com/static/cities/960x720/LON.jpg",
    "https://photo.hotellook.com/static/cities/960x720/KJA.jpg",
    "https://photo.hotellook.com/static/cities/960x720/ABA.jpg"
  ]
  
  // Модель для городов с дополнительной информацией
  private let citiesData = [
    (name: "Москва", country: "Россия", price: 14500, code: "MOW"),
    (name: "Казань", country: "Россия", price: 8900, code: "KZN"),
    (name: "Лондон", country: "Великобритания", price: 32500, code: "LON"),
    (name: "Красноярск", country: "Россия", price: 12500, code: "KJA"),
    (name: "Абакан", country: "Россия", price: 9800, code: "ABA")
  ]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Заголовок
      headerView
      
      // Карусель городов
      citiesScrollView
      
      // Кнопка "Показать все"
      showAllButton
    }
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: 24)
        .fill(.white)
        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 4)
    )
    .padding(.horizontal, 16)
  }
  
  private var headerView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("Увидеть без визы")
          .font(.system(.title3, design: .serif))
          .fontWeight(.bold)
          .foregroundColor(.black)
        
        Text("Популярные направления")
          .font(.caption)
          .foregroundColor(.gray)
      }
      
      Spacer()
      
      Image(systemName: "airplane.departure")
        .font(.title2)
        .foregroundColor(.blue)
        .padding(8)
        .background(Circle().fill(Color.blue.opacity(0.1)))
    }
  }
  
  private var citiesScrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        ForEach(Array(zip(fotosCities.indices, fotosCities)), id: \.0) { index, foto in
          let cityData = citiesData[index % citiesData.count]
          
          NavigationLink(destination: CityDetailView(cityCode: cityData.code)) {
            CityCardView(
              imageUrl: foto,
              cityName: cityData.name,
              country: cityData.country,
              price: cityData.price
            )
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
      .padding(.horizontal, 4)
      .padding(.vertical, 8)
    }
  }
  
  private var showAllButton: some View {
    Button(action: {
      // Действие для показа всех мест
    }) {
      HStack {
        Text("Показать все направления")
          .font(.subheadline)
          .fontWeight(.medium)
        
        Image(systemName: "chevron.right")
          .font(.caption)
      }
      .foregroundColor(.blue)
      .padding(.vertical, 12)
      .padding(.horizontal, 20)
      .background(
        Capsule()
          .stroke(Color.blue, lineWidth: 1)
          .background(Capsule().fill(Color.blue.opacity(0.05)))
      )
    }
    .frame(maxWidth: .infinity)
  }
}

// Карточка города
struct CityCardView: View {
  let imageUrl: String
  let cityName: String
  let country: String
  let price: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Изображение города
      ZStack(alignment: .bottomTrailing) {
        AsyncImage(url: URL(string: imageUrl)) { phase in
          Group {
            switch phase {
            case .empty:
              RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .overlay(
                  ProgressView()
                    .tint(.blue)
                )
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
            case .failure:
              RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .overlay(
                  Image(systemName: "photo")
                    .font(.title2)
                    .foregroundColor(.gray)
                )
            @unknown default:
              EmptyView()
            }
          }
        }
        .frame(width: 160, height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        // Иконка самолета
        Image(systemName: "airplane.circle.fill")
          .font(.title3)
          .foregroundColor(.white)
          .padding(6)
          .background(Circle().fill(Color.blue))
          .padding(8)
          .shadow(radius: 2)
      }
      
      // Информация о городе
      VStack(alignment: .leading, spacing: 4) {
        Text(cityName)
          .font(.headline)
          .foregroundColor(.black)
          .lineLimit(1)
        
        Text(country)
          .font(.caption)
          .foregroundColor(.gray)
          .lineLimit(1)
        
        // Цена
        HStack(spacing: 4) {
          Image(systemName: "rublesign.circle.fill")
            .font(.caption)
            .foregroundColor(.green)
          
          Text("от \(formatPrice(price))")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.black)
        }
      }
    }
    .frame(width: 160)
    .padding(12)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
    )
  }
  
  private func formatPrice(_ price: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
  }
}

// Детальная страница города (заглушка)
struct CityDetailView: View {
  let cityCode: String
  
  var body: some View {
    Text("Детали для города с кодом: \(cityCode)")
      .navigationTitle("Информация о городе")
  }
}

// Кастомный стиль для кнопки
struct GlassButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, 24)
      .padding(.vertical, 12)
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(.ultraThinMaterial)
          .overlay(
            RoundedRectangle(cornerRadius: 20)
              .stroke(Color.white.opacity(0.2), lineWidth: 1)
          )
      )
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
}

// Расширение для ButtonStyle
extension ButtonStyle where Self == GlassButtonStyle {
  static var glass: GlassButtonStyle {
    GlassButtonStyle()
  }
}

// Предварительный просмотр
struct InterestingContent_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 24) {
          InterestingContent()
          
          // Пример как будет выглядеть в контексте
          InterestingContent()
            .padding(.top)
        }
        .padding(.vertical)
      }
      .background(Color(.systemGroupedBackground))
    }
  }
}
