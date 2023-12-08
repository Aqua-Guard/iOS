//
//  ParticipationViewModel.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 5/12/2023.
//

import Foundation
class ParticipationViewModel: ObservableObject {
    
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTcyOGViNTgxMTI3NDRjYzg3MDc5OWUiLCJ1c2VybmFtZSI6ImFtaXJhIiwiaWF0IjoxNzAyMDA2NTMxLCJleHAiOjE3MDIwMTM3MzF9.InEBmy5BV7SJ5NkGoSNo4ZnvgAy9kZ8gwIEuknapkK0"
    
    func addParticipation(eventId : String) {
       
        ParticipationWebService.shared.addParticipation(eventId: eventId, token: token) 
    }
    func deleteParticipation(eventId : String) {
       
        ParticipationWebService.shared.deleteParticipation(eventId: eventId, token: token)
    }
    func isParticipated(eventId: String) async throws -> Bool {
           do {
               return try await ParticipationWebService.shared.isParticipated(eventId: eventId, token: token)
           } catch {
               // Handle errors
               print("Error: \(error)")
               throw error
           }
       }

    
}
