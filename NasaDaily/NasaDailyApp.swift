//
//  NasaDailyApp.swift
//  NasaDaily
//
//  Created by Andreas Hartanto on 2023-02-05.
//

import SwiftUI

@main
struct NasaDailyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
