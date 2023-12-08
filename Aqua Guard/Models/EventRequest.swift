//
//  EventRequest.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 7/12/2023.
//

import Foundation
struct EventRequest: Identifiable {
    var idEvent: String
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
