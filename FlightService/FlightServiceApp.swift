//
//  FlightServiceApp.swift
//  FlightService
//
//  Created by Сергей on 27.11.2025.
//

import SwiftUI
import CoreData

@main
struct FlightServiceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
          MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
