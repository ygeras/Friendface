//
//  UserDataModel.swift
//  Friendface
//
//  Created by Yuri Gerasimchuk on 04.07.2023.
//

import Foundation
import CoreData

class UserDataModel: ObservableObject {
    @Published var users: [CachedUser] = []
    
    func fetchUsers(using moc: NSManagedObjectContext) async {
        guard users.isEmpty else { return }
        
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let users = try decoder.decode([User].self, from: data)
            await MainActor.run {
                updatedCache(with: users, in: moc)
            }
            
        } catch {
            print("Download failed")
        }
        
        await MainActor.run {
            fetchFromCoreData(in: moc)
        }
    }
    
    func updatedCache(with downloadedUsers: [User], in moc: NSManagedObjectContext) {
        for user in downloadedUsers {
            let cachedUser = CachedUser(context: moc)
            
            moc.perform {
                cachedUser.isActive = user.isActive
                cachedUser.name = user.name
                cachedUser.age = Int16(user.age)
                cachedUser.company = user.company
                cachedUser.email = user.email
                cachedUser.address = user.address
                cachedUser.about = user.about
                cachedUser.registered = user.registered
                cachedUser.tags = user.tags.joined(separator: ",")
                
                for friend in user.friends {
                    let cachedFriend = CachedFriend(context: moc)
                    cachedFriend.name = friend.name
                    cachedUser.addToFriends(cachedFriend)
                    
                }
                print("\(user.friends.count) friends for \(cachedUser.name!)")
            }
        }
        
        do {
            try moc.save()
        } catch let error {
            print(error)
        }
        
        
    }
    
    func fetchFromCoreData(in moc: NSManagedObjectContext) {
        let request = CachedUser.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CachedUser.name, ascending: true)]
        
        if let users = try? moc.fetch(request) {
            self.users = users
        }
    }
}
