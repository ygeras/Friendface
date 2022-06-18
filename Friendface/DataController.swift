//
//  DataController.swift
//  Friendface
//
//  Created by Yuri Gerasimchuk on 18.06.2022.
//

import CoreData
import Foundation

class DataContoroller: ObservableObject {
    let container: NSPersistentContainer
    
    init(forPreview: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")
        
        if forPreview {
            container.persistentStoreDescriptions.first!.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        }
        
        if forPreview {
            addMockData(moc: container.viewContext)
        }
    }
}

extension DataContoroller {
    func addMockData(moc: NSManagedObjectContext) {
        let user = CachedUser(context: moc)
        user.isActive = true
        user.name = "Test Name"
        user.age = 23
        user.company = "Company"
        user.email = "sample@gmail.com"
        user.address = "This is Address"
        user.about = "This is about section"
        user.registered = Date()
        user.tags = "No tags"
        
        let friend1 = CachedFriend(context: moc)
        friend1.name = "Jim"
        
        let friend2 = CachedFriend(context: moc)
        friend2.name = "Jack"
        
        user.friends = [friend1, friend2]

        try? moc.save()
    }
}
