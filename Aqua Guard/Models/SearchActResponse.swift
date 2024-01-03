//
//  Actualite.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

import Foundation
struct SearchActResponse : Identifiable , Decodable {
    let idactualite: String
    let userId: String
    let title: String
    let description: String
    let image: String
    let text: String
    let views: Int
    var id: String {
        return idactualite
    }
    
    init?(json: [String: Any]) {

        guard
            let idactualite = json["idactualite"] as? String,
            let userId = json["userId"] as? String,
            let title = json["title"] as? String,
            let description = json["description"] as? String,
            let image = json["image"] as? String,
            let text = json["text"] as? String,
            let views = json["views"] as? Int
       
        else {
            print("Error converting attributs.")

            return nil
        }
        self.idactualite = idactualite
        self.userId = userId
        self.title = title
        self.description = description
        self.image = image
        self.text = text
        self.views = views
 

    }
    
}
