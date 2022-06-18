//
//  ContentView.swift
//  Friendface
//
//  Created by Yuri Gerasimchuk on 17.06.2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var users: FetchedResults<CachedUser>
//    @StateObject var viewModel = UserDataModel()
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink {
                    UserView(user: user)
                } label: {
                    HStack {
                        Circle()
                            .fill(user.isActive ? .green : .red)
                            .frame(width: 30)
                        Text(user.wrappedName)
                        Text("\(user.friendsArray.count)")
                    }
                }
            }
            .navigationTitle("Friendface")
            .task {
                await fetchUsers()
//                await viewModel.fetchUsers(using: moc)
            }
        }
    }
    
    func fetchUsers() async {
        guard users.isEmpty else { return }
        
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let users = try decoder.decode([User].self, from: data)
//            await MainActor.run {
                updatedCache(with: users)
//            }
        } catch {
            print("Download failed")
        }
    }
    
    func updatedCache(with downloadedUsers: [User]) {
        for user in downloadedUsers {
            let cachedUser = CachedUser(context: moc)
            
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

            
            do {
                try moc.save()
            } catch let error {
                print(error)
            }
            
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, DataContoroller(forPreview: true).container.viewContext)
    }
}
