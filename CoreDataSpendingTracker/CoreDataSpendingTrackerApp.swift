//
//  CoreDataSpendingTrackerApp.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/11.
//

import SwiftUI

@main
struct CoreDataSpendingTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
