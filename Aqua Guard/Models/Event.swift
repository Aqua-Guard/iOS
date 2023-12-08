//
//  Event.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import Foundation

struct Event: Identifiable,Codable  {
    var idEvent: String
    var userName: String
    var userImage: String
    var eventName: String
    var description: String
    var eventImage: String
    var dateDebut: Date
    var dateFin: Date
    var lieu: String
    
    var id: String {
        return idEvent
    }
    
    init?(json: [String: Any]) {
        let dateFormatter = ISO8601DateFormatter()
           dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
           dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard
            let idEvent = json["idEvent"] as? String,
            let userName = json["userName"] as? String,
            let userImage = json["userImage"] as? String,
            let eventName = json["eventName"] as? String,
            let description = json["description"] as? String,
            let eventImage = json["eventImage"] as? String,
            let dateDebutString = json["DateDebut"] as? String,
            let dateFinString = json["DateFin"] as? String,
            let dateDebut = dateFormatter.date(from: dateDebutString),
            let dateFin = dateFormatter.date(from: dateFinString),
            let lieu = json["lieu"] as? String
        else {
            print("Error converting dates.")

            return nil
        }

        self.idEvent = idEvent
        self.userName = userName
        self.userImage = userImage
        self.eventName = eventName
        self.description = description
        self.eventImage = eventImage
        self.dateDebut = dateDebut
        self.dateFin = dateFin
        self.lieu = lieu
    }
}
