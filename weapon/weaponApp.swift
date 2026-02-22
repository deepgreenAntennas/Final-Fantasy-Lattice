//
//  weaponApp.swift
//  weapon
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import SwiftUI

@main
struct weaponApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
