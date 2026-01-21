import Foundation

struct FlightResponse: Codable {
  let data: [String: [String: FlightData]]
  let currency: String
  let success: Bool
  
  func convertToFlights(origin: String) -> [Flight] {
    var flights: [Flight] = []
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
    
    for (destination, flightsDict) in data {
      for (_, flightData) in flightsDict {
        guard let departureTime = dateFormatter.date(from: flightData.departureAt ?? "") else { continue }
        let returnTime = flightData.returnAt.flatMap { dateFormatter.date(from: $0) }
        
        let flightOrigin = origin
        
        let flight = Flight(
          airline: flightData.airline,
          flightNumber: flightData.flightNumber.map { "\($0)" } ?? "N/A",
          departureTime: departureTime,
          arrivalTime: returnTime,
          price: flightData.price,
          origin: flightOrigin,
          destination: destination,
          currency: currency,
          isReturn: flightData.returnAt != nil,
          returnTime: returnTime
        )
        flights.append(flight)
      }
    }
    return flights
  }
}

struct FlightData: Codable {
  let price: Int
  let airline: String
  let flightNumber: Int?
  let departureAt: String?
  let returnAt: String?
  let expiresAt: String
  let origin: String?
  
  
  enum CodingKeys: String, CodingKey {
    case price, airline
    case flightNumber = "flight_number"
    case departureAt = "departure_at"
    case returnAt = "return_at"
    case expiresAt = "expires_at"
    case origin
  }
}

struct Flight: Identifiable {
  let id = UUID()
  let airline: String
  let flightNumber: String
  let departureTime: Date
  let arrivalTime: Date?
  let price: Int
  let origin: String
  let destination: String
  let currency: String
  let isReturn: Bool
  let returnTime: Date?
  
  var formattedPrice: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currency.uppercased()
    formatter.currencySymbol = getCurrencySymbol(currency)
    return formatter.string(from: NSNumber(value: price)) ?? "\(price) \(currency.uppercased())"
  }
  
  var durationUntilDeparture: String {
    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .hour], from: now, to: departureTime)
    
    if let days = components.day, days > 0 {
      return "Через \(days) дн."
    } else if let hours = components.hour, hours > 0 {
      return "Через \(hours) ч."
    } else {
      return "Скоро"
    }
  }
  
  private func getCurrencySymbol(_ currency: String) -> String {
    switch currency.lowercased() {
    case "rub": return "₽"
    case "usd": return "$"
    case "eur": return "€"
    default: return currency.uppercased()
    }
  }
}
