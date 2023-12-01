//
//  LoginResponseModel.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import Foundation

struct LoginResponseModel: Codable {
    var token: String
    var username: String
    var email: String
    var id: String
    var role: String
    var isActivated: Bool
    var nbPts: Int
}
