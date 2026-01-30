//import SwiftUI
//
//struct FlightCard: View {
//  let flights: [Flight]
//
//  var body: some View {
//
//    ForEach(flights) { flight in
//      NavigationLink {
//        DetailFlightView(flight: flight)
//      } label: {
//        VStack(alignment: .leading) {
//          Text(flight.airline)
//          Text("Time: \(flight.departureTime)")
//          Text("Price: \(flight.price) \(flight.currency.uppercased())")
//          Text("\(flight.origin) --> \( flight.destination)")
//          Text("Return: \(String(describing: flight.returnTime))")
//        }
//        .padding()
//        .background(.white)
//        .cornerRadius(20)
//      }
//    }
//  }
//}

import SwiftUI

struct FlightCard: View {
  let flights: [Flight]
  
  var body: some View {
    VStack(spacing: 12) {
      ForEach(flights) { flight in
        NavigationLink {
          DetailFlightView(flight: flight)
        } label: {
          FlightRow(flight: flight)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(.horizontal)
  }
}

struct FlightRow: View {
  let flight: Flight
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Верхняя часть - авиакомпания и цена
      HStack {
        // Авиакомпания
        VStack(alignment: .leading, spacing: 2) {
          Text(flight.airline)
            .font(.headline)
            .foregroundColor(.primary)
          
          Text("\(flight.origin) → \(flight.destination)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        
        Spacer()
        
        // Цена
        VStack(alignment: .trailing, spacing: 2) {
          Text("\(flight.price) \(flight.currency.uppercased())")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
          
          Text("за билет")
            .font(.caption2)
            .foregroundColor(.gray)
        }
      }
      
      Divider()
        .padding(.horizontal, -16)
      
      // Нижняя часть - время
      HStack(spacing: 20) {
        // Вылет
        TimeView(
          time: "\(flight.departureTime)",
          label: "Вылет",
          icon: "airplane.departure"
        )
        
        // Возврат (если есть)
        if let returnTime = flight.returnTime {
          Divider()
            .frame(height: 30)
          
          TimeView(
            time: "\(returnTime)",
            label: "Возврат",
            icon: "airplane.arrival"
          )
        } else {
          Spacer()
          
          Label("В одну сторону", systemImage: "arrow.right")
            .font(.caption)
            .foregroundColor(.orange)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color.orange.opacity(0.1)))
        }
      }
    }
    .padding(16)
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
}

struct TimeView: View {
  let time: String
  let label: String
  let icon: String
  
  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: icon)
        .font(.caption)
        .foregroundColor(.blue)
        .frame(width: 20)
      
      VStack(alignment: .leading, spacing: 2) {
        Text(time)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(.primary)
        
        Text(label)
          .font(.caption2)
          .foregroundColor(.secondary)
      }
    }
  }
}

// Вспомогательное расширение для форматирования времени
extension FlightCard {
  // Можно добавить функции форматирования если нужно
  private func formatTime(_ timeString: String) -> String {
    // Преобразование формата времени если нужно
    return timeString
  }
}

// Предварительный просмотр
struct FlightCard_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      FlightCard(
        flights: [
          Flight(
            airline: "Air Canada",
            flightNumber: "33",
            departureTime: .now,
            arrivalTime: .now + 3600,
            price: 23498,
            origin: "KJA",
            destination: "MOW",
            currency: "rub",
            isReturn: false,
            returnTime: .now + 7200
            
          ),
          Flight(
            airline: "Air Canada",
            flightNumber: "23",
            departureTime: .now + 1000,
            arrivalTime: .now + 4600,
            price: 213442,
            origin: "MOW",
            destination: "KJA",
            currency: "rub",
            isReturn: false,
            returnTime: .now + 11200
          )
        ]
      )
      .padding(.vertical)
      .background(Color.gray.opacity(0.05))
    }
  }
}
