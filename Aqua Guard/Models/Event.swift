//
//  Event.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import Foundation

struct Event: Identifiable  {
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
}
