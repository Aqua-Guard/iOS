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
    
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTZlMzQ4MDJiNTA3YzgyNTVmZmQ5YzYiLCJ1c2VybmFtZSI6InlvdXNzZWYiLCJpYXQiOjE3MDE5ODk1NDgsImV4cCI6MTcwMTk5Njc0OH0.9BkayOlbhiUY1lX0XzHXz0-hFEsQfCAblLXQ9mv33EA"

    init()  {
      /*  let event1 = Event(idEvent: UUID().uuidString, userName: "John Doe", userImage: "john_image", eventName: "Event 1", description: "Une initiative communautaire pour nettoyer les plages et protéger l'environnement.", eventImage: "sidi_bou_said", dateDebut: Date(), dateFin: Date(), lieu: "Location 1")
        
        let event2 = Event(idEvent: UUID().uuidString, userName: "Jane Doe", userImage: "jane_image", eventName: "Event 2", description: "Description for Event 2", eventImage: "sidi_bou_said", dateDebut: Date(), dateFin: Date(), lieu: "Location 2")*/

        // Initialize the list of events with default data
         fetchMyEvents()
    }
    
    func fetchMyEvents() {
       
        EventWebService.shared.fetchUserEvents(token: token) { [weak self] events in
            // Update the events array on the main thread
            DispatchQueue.main.async {
                self?.events = events ?? []
            }
        }
    }

    func createEvent(eventName: String, description: String, eventImage: Data, dateDebut: Date, dateFin: Date, lieu: String) {
        // Convert the eventImage String to a URL
        if let imageURL = URL(string: eventImage.base64EncodedString()) {
            // Create a new Event instance
            let newEvent = EventRequest(idEvent: UUID().uuidString, eventName: eventName, description: description, eventImage: imageURL.path(), dateDebut: dateDebut, dateFin: dateFin, lieu: lieu)

            eventWebService.addEvent(token: token, event: newEvent, image: eventImage ) { result in
                switch result {
                case .success:
                    // Handle success, if needed
                    print("Event added successfully.")
                case .failure(let error):
                    // Handle the error
                    print("Error adding event: \(error)")
                }
            }
        } else {
            // Handle the case where eventImage is not a valid URL
            print("Invalid image URL")
        }
    }


    func updateEvent(eventId: String,eventName: String,description: String,eventImage: Data,dateDebut: Date,dateFin: Date,lieu: String) {
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

            eventWebService.updateEvent(
                token: token,
                eventId: eventId,
                event: updatedEvent,
                image: eventImage
            ) { result in
                switch result {
                case .success:
                    // Handle success, if needed
                    print("Event updated successfully.")
                case .failure(let error):
                    // Handle the error
                    print("Error updating event: \(error)")
                }
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
                
                // If the deletion is successful, you can perform any additional actions here
                print("Event deleted successfully.")
                
            } catch {
                // Handle errors appropriately
                print("Error deleting event: \(error)")
            }
        }
    }

}


