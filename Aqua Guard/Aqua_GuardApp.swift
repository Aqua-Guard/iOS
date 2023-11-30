//
//  Aqua_GuardApp.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

@main
struct Aqua_GuardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PostViewModel())
               // .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
