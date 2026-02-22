//
//  Final_Fantasy_Lattice__Soldiers_Of_FireApp.swift
//  Final Fantasy Lattice: Soldiers Of Fire
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import SwiftUI

@main
struct Final_Fantasy_Lattice__Soldiers_Of_FireApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
