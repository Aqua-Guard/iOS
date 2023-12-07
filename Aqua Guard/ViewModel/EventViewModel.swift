//
//  EventViewModel.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 29/11/2023.
//

import Foundation
class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    @Published var isCreatingEvent: Bool = false
    @Published var eventToUpdate: Event? = nil
    @Published var isPresented: Bool = false

    init() {
       /* let event1 = Event(idEvent: UUID().uuidString, userName: "John Doe", userImage: "john_image", eventName: "Event 1", description: "Une initiative communautaire pour nettoyer les plages et protéger l'environnement.", eventImage: "sidi_bou_said", dateDebut: Date(), dateFin: Date(), lieu: "Location 1")
        
        let event2 = Event(idEvent: UUID().uuidString, userName: "Jane Doe", userImage: "jane_image", eventName: "Event 2", description: "Description for Event 2", eventImage: "sidi_bou_said", dateDebut: Date(), dateFin: Date(), lieu: "Location 2")*/

        // Initialize the list of events with default data
        fetchEvents()
    }
   

      func fetchEvents() {
          let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTRkZjE4YjUzNWVjMDRlZmVkYWJiMGIiLCJ1c2VybmFtZSI6Im1hbGVrIiwiaWF0IjoxNzAxOTc0MzM4LCJleHAiOjE3MDE5ODE1Mzh9.64C_kBmyHxhNbEjzSLodm4Mt9O6_3U2V3mCT6cPinqk"
          EventWebService.shared.fetchEvents(token: token) { [weak self] events in
              // Update the events array on the main thread
              DispatchQueue.main.async {
                  self?.events = events ?? []
              }
          }
      }

   
}

