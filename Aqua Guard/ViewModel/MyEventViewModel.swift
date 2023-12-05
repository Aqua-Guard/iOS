//
//  MyEventViewModel.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 29/11/2023.
//

import Foundation
class MyEventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isCreatingEvent: Bool = false
    @Published var eventToUpdate: Event? = nil
    @Published var isPresented: Bool = false

    init() {
      /*  let event1 = Event(idEvent: UUID().uuidString, userName: "John Doe", userImage: "john_image", eventName: "Event 1", description: "Une initiative communautaire pour nettoyer les plages et protéger l'environnement.", eventImage: "sidi_bou_said", dateDebut: Date(), dateFin: Date(), lieu: "Location 1")
        
        let event2 = Event(idEvent: UUID().uuidString, userName: "Jane Doe", userImage: "jane_image", eventName: "Event 2", description: "Description for Event 2", eventImage: "sidi_bou_said", dateDebut: Date(), dateFin: Date(), lieu: "Location 2")*/

        // Initialize the list of events with default data
        fetchEvents()
    }
    
  
    func fetchEvents() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTRkZjE4YjUzNWVjMDRlZmVkYWJiMGIiLCJ1c2VybmFtZSI6Im1hbGVrIiwiaWF0IjoxNzAxNzkxMDM1LCJleHAiOjE3MDE3OTgyMzV9.K5Mi3VE8X-2m5BeBNMNW00I6rMUDIaDuLYdkJfMUSbs"
        EventWebService.shared.fetchEvents(token: token) { [weak self] events in
            // Update the events array on the main thread
            DispatchQueue.main.async {
                self?.events = events ?? []
            }
        }
    }

    func createEvent(userName: String, userImage: String, eventName: String, description: String, eventImage: String, dateDebut: Date, dateFin: Date, lieu: String) {
       /* let newEvent = Event(idEvent: UUID().uuidString, userName: userName, userImage: userImage, eventName: eventName, description: description, eventImage: eventImage, dateDebut: dateDebut, dateFin: dateFin, lieu: lieu)
        events.append(newEvent)*/
    }

    func updateEvent(eventID: String, newUserName: String, newUserImage: String, newEventName: String, newDescription: String, newEventImage: String, newDateDebut: Date, newDateFin: Date, newLieu: String) {
        if let index = events.firstIndex(where: { $0.idEvent == eventID }) {
            events[index].userName = newUserName
            events[index].userImage = newUserImage
            events[index].eventName = newEventName
            events[index].description = newDescription
            events[index].eventImage = newEventImage
//            events[index].dateDebut = newDateDebut
//            events[index].dateFin = newDateFin
            events[index].lieu = newLieu
        }
    }

    func deleteEvent(eventID: String) {
        events.removeAll{ $0.idEvent == eventID }
    }
}


