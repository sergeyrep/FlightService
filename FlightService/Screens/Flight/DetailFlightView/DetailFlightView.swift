//import SwiftUI
//
//struct DetailFlightView: View {
//  
//  let flight: Flight
//  
//  var body: some View {
//    ScrollView {
//      header
//      tariffCondition
//      VStack(alignment: .leading) {
//        Text("\(flight.origin.uppercased()) - \(flight.destination.uppercased())")
//          .font(.title3.bold())
//        Text("5ч 20мин в пути")
//      }
//      detailInfo
//      
//    }
//    .background(.gray.opacity(0.3))
//    .ignoresSafeArea()
//  }
//  
//  private var detailInfo: some View {
//    VStack(alignment: .leading) {
//      HStack {
//        Image(systemName: "airplane.departure")
//        
//        VStack(alignment: .leading) {
//          Text(flight.airline)
//            .font(.title3.bold())
//          Text("5ч 20мин в полете")
//        }
//        Spacer()
//        
//        Button("Подробнее") {
//          
//        }
//        //.buttonStyle(.borderedProminent)
//        .padding(5)
//        .background(.gray.opacity(0.3))
//        .foregroundStyle(.black)
//        .cornerRadius(13)
//      }
//      
//      HStack {
//        ZStack {
//          Rectangle()
//            .fill(Color.gray.opacity(0.3))
//            .frame(maxWidth: 2, maxHeight: .infinity)
//            .padding(0)
//          VStack {
//            Image(systemName: "record.circle.fill")
//            Spacer()
//            Image(systemName: "record.circle.fill")
//          }
//        }
//        
//        VStack(alignment: .leading) {
//          Text("\(flight.departureTime)")
//            .font(.title3.bold())
//          Text("(hello)")
//            .font(.caption)
//            .foregroundStyle(.black.opacity(0.6))
//          
//          if let arrivalTime = flight.arrivalTime {
//            Text("\(arrivalTime)")
//              .font(.title3.bold())
//          }
//          
//          Text("30 dec, bt")
//            .font(.caption)
//            .foregroundStyle(.black.opacity(0.6))
//        }
//      }
//    }
//    .background(.white)
//    .cornerRadius(20)
//  }
//  
//  private var header: some View {
//    VStack {
//      Image(systemName: "banknote")
//        .foregroundStyle(Color.green)
//      Text("билет из \(flight.origin) в \(flight.destination)")
//      //.searchable(text: $search)
//    }
//  }
//  
//  private var tariffCondition: some View {
//    VStack(alignment: .leading) {
//      Text("Условия тарифа")
//        .font(.title2.bold())
//      
//      VStack(alignment: .leading) {
//        HStack {
//          Image(systemName: "checkmark.circle.fill")
//            .foregroundStyle(Color.green)
//          Text("Ручная кладь")
//        }
//        HStack {
//          Image(systemName: "xmark")
//          Text("Без багажа")
//        }
//        HStack {
//          Image(systemName: "checkmark.circle.fill")
//            .foregroundStyle(Color.green)
//          Text("Обмен платный")
//        }
//        HStack {
//          Image(systemName: "xmark")
//          Text("Без возврата")
//        }
//      }
//    }
//    .frame(maxWidth: .infinity)
//    .background(.white)
//    .cornerRadius(20)
//    .padding()
//  }
//}
//
//#Preview {
//  DetailFlightView(flight: .init(airline: "", flightNumber: "", departureTime: .now, arrivalTime: .now, price: 3, origin: "", destination: "", currency: "", isReturn: false, returnTime: .now))
//}
import SwiftUI

struct DetailFlightView: View {
  let flight: Flight
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        // 1. Шапка с ценой
        headerView
        
        // 2. Карточка рейса
        flightCardView
        
        // 3. Условия тарифа
        tariffConditionsView
        
        // 4. Детали рейса
        flightDetailsView
      }
      .padding()
    }
    .background(Color(.systemGray6))
    .navigationBarTitleDisplayMode(.inline)
  }
  
  // MARK: - Шапка с ценой
  private var headerView: some View {
    VStack(spacing: 12) {
      HStack {
        Image(systemName: "airplane.circle.fill")
          .font(.largeTitle)
          .foregroundColor(.blue)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("\(flight.origin) → \(flight.destination)")
            .font(.title3)
            .fontWeight(.semibold)
          
          Text("Прямой рейс • Эконом")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        
        Spacer()
      }
      
      // Цена
      HStack {
        Text("\(flight.price) \(flight.currency.uppercased())")
          .font(.system(size: 32, weight: .bold))
          .foregroundColor(.primary)
        
        Text("за пассажира")
          .font(.caption)
          .foregroundColor(.secondary)
          .padding(.top, 8)
      }
      .frame(maxWidth: .infinity)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
    )
  }
  
  // MARK: - Карточка рейса
  private var flightCardView: some View {
    VStack(spacing: 0) {
      // Авиакомпания
      HStack {
        Image(systemName: "airplane")
          .foregroundColor(.blue)
        
        VStack(alignment: .leading, spacing: 2) {
          Text(flight.airline)
            .font(.headline)
          
          //   if let flightNumber = flight.flightNumber {
          Text("Рейс \(flight.flightNumber)")
            .font(.caption)
            .foregroundColor(.secondary)
          //    }
        }
        
        Spacer()
        
        if flight.isReturn {
          Label("Туда-обратно", systemImage: "arrow.triangle.2.circlepath")
            .font(.caption)
            .foregroundColor(.orange)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color.orange.opacity(0.1)))
        }
      }
      .padding(.horizontal)
      .padding(.vertical, 12)
      
      Divider()
      
      // Время вылета/прилета
      HStack(spacing: 20) {
        departureView
        
        // Линия с самолетом
        VStack(spacing: 4) {
          Circle()
            .fill(Color.blue)
            .frame(width: 6, height: 6)
          
          Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 80, height: 1)
          
          Image(systemName: "airplane")
            .font(.caption)
            .foregroundColor(.blue)
          
          Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 80, height: 1)
          
          Circle()
            .fill(Color.blue)
            .frame(width: 6, height: 6)
        }
        
        arrivalView
      }
      .padding()
      
      // Время в пути
      HStack {
        Image(systemName: "clock")
          .font(.caption)
          .foregroundColor(.secondary)
        
        Text("5ч 20мин в пути")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding(.bottom, 12)
    }
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.white)
    )
  }
  
  private var departureView: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(formatTime(flight.departureTime))
        .font(.title3)
        .fontWeight(.bold)
      
      Text("Вылет")
        .font(.caption)
        .foregroundColor(.secondary)
      
      Text(flight.origin)
        .font(.caption)
        .foregroundColor(.primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var arrivalView: some View {
    VStack(alignment: .trailing, spacing: 4) {
      if let arrivalTime = flight.arrivalTime {
        Text(formatTime(arrivalTime))
          .font(.title3)
          .fontWeight(.bold)
      }
      
      Text("Прилет")
        .font(.caption)
        .foregroundColor(.secondary)
      
      Text(flight.destination)
        .font(.caption)
        .foregroundColor(.primary)
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
  }
  
  // MARK: - Условия тарифа
  private var tariffConditionsView: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Условия тарифа")
        .font(.headline)
      
      VStack(spacing: 12) {
        ConditionRow(
          icon: "bag.carry-on.fill",
          text: "Ручная кладь: 1 место × 5кг",
          isIncluded: true
        )
        
        ConditionRow(
          icon: "suitcase.fill",
          text: "Багаж: не включен",
          isIncluded: false
        )
        
        ConditionRow(
          icon: "arrow.triangle.2.circlepath",
          text: "Обмен: платный",
          isIncluded: true
        )
        
        ConditionRow(
          icon: "arrow.uturn.left",
          text: "Возврат: невозможен",
          isIncluded: false
        )
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.white)
    )
  }
  
  // MARK: - Детали рейса
  private var flightDetailsView: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Детали рейса")
        .font(.headline)
      
      VStack(spacing: 12) {
        DetailRow(
          icon: "calendar",
          title: "Дата вылета",
          value: formatDate(flight.departureTime)
        )
        
        if let returnTime = flight.returnTime {
          DetailRow(
            icon: "calendar.badge.clock",
            title: "Дата возврата",
            value: formatDate(returnTime)
          )
        }
        
        DetailRow(
          icon: "airplane.circle",
          title: "Тип рейса",
          value: "Прямой"
        )
        
        DetailRow(
          icon: "person.2.fill",
          title: "Класс",
          value: "Эконом"
        )
      }
      
      Button(action: {
        // Действие покупки
      }) {
        HStack {
          Image(systemName: "cart.fill")
          Text("Купить билет")
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.blue)
        .cornerRadius(12)
      }
      .padding(.top, 8)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.white)
    )
  }
  
  // MARK: - Вспомогательные методы
  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }
  
  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
}

// MARK: - Компоненты
struct ConditionRow: View {
  let icon: String
  let text: String
  let isIncluded: Bool
  
  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: icon)
        .foregroundColor(isIncluded ? .green : .gray)
        .frame(width: 24)
      
      Text(text)
        .font(.subheadline)
      
      Spacer()
      
      Image(systemName: isIncluded ? "checkmark.circle.fill" : "xmark.circle.fill")
        .foregroundColor(isIncluded ? .green : .gray)
    }
  }
}

struct DetailRow: View {
  let icon: String
  let title: String
  let value: String
  
  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: icon)
        .foregroundColor(.blue)
        .frame(width: 24)
      
      Text(title)
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      Spacer()
      
      Text(value)
        .font(.subheadline)
        .fontWeight(.medium)
    }
  }
}

// MARK: - Preview
struct DetailFlightView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailFlightView(flight: Flight(
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
      ))
      .navigationTitle("Детали рейса")
    }
  }
}
