import SwiftUI
import CoreData
import Combine

@main
struct FlightServiceApp: App {
  let persistenceController = PersistenceController.shared
  private let container = Factory()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        //.environmentObject(container)
    }
  }
}

final class Factory {
  static let shared = Factory()
  
  lazy var networkService: NetworkService = {
    NetworkService()
  }()
  
  lazy var flightService: FlightServiceProtocol = {
    FlightService(networkService: networkService)
  }()
  
  lazy var locationService: DefenitionLocationServiceProtocol = {
    DefenitionLocationService(networkService: networkService)
  }()
  
  lazy var popularDirectionsService: PopularDirectionsServiceProtocol = {
    PopularDirectionsService(networkService: networkService)
  }()
  
  lazy var cityFotoService: CityFotoServiceProtocol = {
    CityFotoServices(networkService: networkService)
  }()
  
  lazy var searchIATAService: SearchIATAServiceProtocol = {
    SearchIATAService()
  }()
  
  init() {}
  
  func makeMainViewModel() -> MainViewModel {
    MainViewModel(locationService: locationService)
  }
}
