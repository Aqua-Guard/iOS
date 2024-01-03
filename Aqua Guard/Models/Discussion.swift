//
//  Discution.swift
//  Aqua Guard
//
//  Created by Mac Mini 5 on 15/12/2023.
//

import Foundation


struct Discussion : Identifiable , Decodable {
    let idmessage: String
    let idreclamation: String
    let userRole: String
    let createdAt: String
    let visibility: Bool
    let message :String
    var id: String {
        return idreclamation
    }
    
    init?(json: [String: Any]) {

        guard
            let idmessage = json["idmessage"] as? String,
            let visibility = json["visibility"] as? Bool,
            let message = json["message"] as? String,
            let idreclamation = json["idreclamation"] as? String,
            let userRole = json["userRole"] as? String,
            let createdAt = json["createdAt"] as? String
            

        else {
            print("Error converting attributs.")

            return nil
        }
        self.idreclamation = idreclamation
        self.userRole = userRole
        self.createdAt = createdAt
        self.message = message
        self.idmessage = idmessage
        self.visibility = visibility
    }
    
}
