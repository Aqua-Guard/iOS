//
//  Reclamation.swift
//  Aqua Guard
//
//  Created by Mac Mini 5 on 14/12/2023.
//

import Foundation
//
//  Actualite.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

struct Reclamation : Identifiable , Decodable {
    let idreclamation: String
    let userId: String
    let title: String
    let image: String
    let date: String
    let description:String
    var id: String {
        return idreclamation
    }
    
    init?(json: [String: Any]) {

        guard
            let idreclamation = json["idreclamation"] as? String,
            let userId = json["userId"] as? String,
            let title = json["title"] as? String,
            let image = json["image"] as? String,
            let date = json["date"] as? String,
            let description = json["description"] as? String

        else {
            print("Error converting attributs.")

            return nil
        }
        self.idreclamation = idreclamation
        self.userId = userId
        self.title = title
        self.image = image
        self.date = date
        self.description=description

 

    }
    
}
