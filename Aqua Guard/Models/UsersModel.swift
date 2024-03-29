//
//  UsersModel.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import Foundation

struct UsersModel: Identifiable{
    var id: String
    let email: String
    let firstName: String
    let lastName: String
    let username: String
    let password: String
    let image: String
    
}
