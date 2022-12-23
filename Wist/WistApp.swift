//
//  WistApp.swift
//  Wist
//
//  Created by Jonas Bäumer on 07.10.22.
//

import SwiftUI

@main
struct WistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
