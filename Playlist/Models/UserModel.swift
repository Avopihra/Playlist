//
//  UserModel.swift
//  Playlist
//
//  Created by Viktoriya on 29.10.2021.
//

import Foundation

struct User: Codable {
    let firstName: String
    let secondName: String
    let phone: String
    let email: String
    let password: String
    let age: Date
}
