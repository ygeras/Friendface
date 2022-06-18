//
//  User.swift
//  Friendface
//
//  Created by Yuri Gerasimchuk on 17.06.2022.
//

import Foundation

struct User: Codable {
    let isActive: Bool
    let name: String
    let age: Int
    let email: String
    let about: String
    let address: String
    let company: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
    
    static let sample = User(isActive: true, name: "", age: 8, email: "", about: "", address: "", company: "", registered: Date(), tags: [String](), friends: [Friend]())
}
