//
//  MyEventViewModel.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 29/11/2023.
//

import Foundation
class MyEventViewModel: ObservableObject {
    let eventWebService = EventWebService()
    @Published var events: [Event] = []
    @Published var isCreatingEvent: Bool = false
    @Published var eventToUpdate: Event? = nil
    @Published var isPresented: Bool = false
    
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTRkZjE4YjUzNWVjMDRlZmVkYWJiMGIiLCJ1c2VybmFtZSI6Im1hbGVrIiwiaWF0IjoxNzAxOTkzNDY0LCJleHAiOjE3MDIwMDA2NjR9.MVLuWHM2fpWHfCKqIVPFo5WlMBJL8huaNhIv6sZ1zAg"

    /*init() async  {
      /*  let event1 = Event(idEvent: UUID().uuidString, userName: "John Doe", userImage: "john_image", eventName: "Event 1", description: "Une initiative communautaire pour nettoyer les plages et protéger l'environnement.", eventImage: "sidi_bou_said", dateDebut: Date(), dateFin: Date(), lieu: "Location 1")
        
        let event2 = Event(idEvent: UUID().uuidString, userName: "Jane Doe", userImage: "jane_image", eventName: "Event 2", description: "Description for Event 2", eventImage: "sidi_bou_said", dateDebut: Date(), dateFin: Date(), lieu: "Location 2")*/

        // Initialize the list of events with default data
         await fetchMyEvents()
    }*/
    
    func fetchMyEvents() async {
        do{
        EventWebService.shared.fetchUserEvents(token: token) { [weak self] events in
            // Update the events array on the main thread
            DispatchQueue.main.async {
                self?.events = events ?? []
            }
        }
    
            }

    }

    func createEvent(eventName: String, description: String, eventImage: Data, dateDebut: Date, dateFin: Date, lieu: String) async {
        // Convert the eventImage String to a URL
        if let imageURL = URL(string: eventImage.base64EncodedString()) {
            // Create a new Event instance
            let newEvent = EventRequest(idEvent: UUID().uuidString, eventName: eventName, description: description, eventImage: imageURL.path(), dateDebut: dateDebut, dateFin: dateFin, lieu: lieu)
            
            do {
                let success = try await eventWebService.addEvent(token: token, event: newEvent, image: eventImage)
                
                if success {
                    EventWebService.shared.fetchUserEvents(token: token) { [weak self] events in
                        // Update the events array on the main thread
                        DispatchQueue.main.async {
                            self?.events = events ?? []
                        }
                    }
                }
            } catch {
                print("Error adding event: \(error)")
            }

        } else {
            // Handle the case where eventImage is not a valid URL
            print("Invalid image URL")
        }
    }

    func updateEvent(eventId: String, eventName: String, description: String, eventImage: Data, dateDebut: Date, dateFin: Date, lieu: String) async {
        if let imageURL = URL(string: eventImage.base64EncodedString()) {
            let updatedEvent = EventRequest(
                idEvent: eventId,
                eventName: eventName,
                description: description,
                eventImage: imageURL.path(),
                dateDebut: dateDebut,
                dateFin: dateFin,
                lieu: lieu
            )
            do {
                let success = try await eventWebService.updateEvent(
                    token: token,
                    eventId: eventId,
                    event: updatedEvent,
                    image: eventImage
                )
                
                if success {
                    DispatchQueue.main.async {
                        if let eventIndex = self.events.firstIndex(where: { $0.idEvent == eventId }) {
                            self.events.remove(at: eventIndex)
                        }
                    }
                }
            } catch {
                print("Error updating event: \(error)")
            }
        } else {
            print("Invalid image URL")
        }
    }


 
    func deleteEvent(eventId: String)  {
        Task {
            do {
              
                // Call the asynchronous deleteEvent method
                try await eventWebService.deleteEvent(eventId: eventId, token: token)
                DispatchQueue.main.async {
                    if let eventIndex = self.events.firstIndex(where: { $0.idEvent == eventId }) {
                        self.events.remove(at: eventIndex)
                    }
                }

                // If the deletion is successful, you can perform any additional actions here
                print("Event deleted successfully.")
                
            } catch {
                // Handle errors appropriately
                print("Error deleting event: \(error)")
            }
        }
    }

}


