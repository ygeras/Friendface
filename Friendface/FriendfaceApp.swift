//
//  FriendfaceApp.swift
//  Friendface
//
//  Created by Yuri Gerasimchuk on 17.06.2022.
//

import SwiftUI

@main
struct FriendfaceApp: App {
    @StateObject var dataController = DataContoroller()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
