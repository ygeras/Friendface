//
//  UserView.swift
//  Friendface
//
//  Created by Yuri Gerasimchuk on 17.06.2022.
//

import SwiftUI

struct UserView: View {
    let user: CachedUser
    
    var body: some View {
        List {
            
            Section {
                Text(user.wrappedAbout)
                    .padding()
            } header: {
                Text("About")
            }
            
            Section {
                Text("Address: \(user.wrappedAddress)")
                Text("Company: \(user.wrappedCompany)")
            } header: {
                Text("Contact details")
            }
            
            Section {
                ForEach(user.friendsArray) { friend in
                    Text(friend.wrappedName)
                }
            } header: {
                Text("Friends")
            }
        }
        .listStyle(.grouped)
        .navigationTitle(user.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: CachedUser(context: DataContoroller(forPreview: true).container.viewContext))
    }
}
