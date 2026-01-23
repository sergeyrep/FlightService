import Foundation

protocol DefenitionLocationServiceProtocol {
  var currentLocation: UserIata? { get }
  func sendLocation() async throws -> UserIata
}

final class DefenitionLocationService: DefenitionLocationServiceProtocol {
  
  //static let shared: DefenitionLocationServiceProtocol = DefenitionLocationService()
  //MARK: -Зависимости (получаем через конструктор)
  private var networkService: NetworkServiceProtocol
  private let baseURL: String = "https://www.travelpayouts.com"
  
  // MARK: - Свойства
  var currentLocation: UserIata?
  
  // MARK: - Инициализация
  init(
    networkService: NetworkServiceProtocol/* = NetworkService()*/
  ) {
    self.networkService = networkService
    print("📍 DefenitionLocationService создан")
  }
  
  // MARK: - Методы
  func sendLocation() async throws -> UserIata {
    
    let endpoint: EndpointProtocol = ApiMethod.fetchLocation
    
    do {
      let response: UserIata = try await networkService.fetchData(endpoint, baseURL: baseURL)
      
      await MainActor.run {
        self.currentLocation = response
      }
      return response
    } catch {
      print("invalid response service")
      let fallbackLocation = UserIata(
        iata: "MOW",
        name: "Москва",
        countryName: "RU",
        coordinates: nil
      )
      
      await MainActor.run {
        self.currentLocation = fallbackLocation
      }
      
      throw LocationError.failedToDetect
    }
  }
}

// MARK: - Ошибки
extension DefenitionLocationService {
  enum LocationError: LocalizedError {
    case failedToDetect
    
    var errorDescription: String? {
      switch self {
      case .failedToDetect:
        return "Не удалось определить местоположение"
      }
    }
  }
}
//GET https://www.travelpayouts.com/whereami?locale=ru&callback=useriata&ip=62.105.128.0
