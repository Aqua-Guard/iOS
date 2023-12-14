//
//  ParticipationViewModel.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 5/12/2023.
//

import Foundation
class ParticipationViewModel: ObservableObject {
    
    @Published var participations: [Participation] = []
    
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTUxMTM1MjY3ZjkyM2Q1NDg3OGFmYTkiLCJ1c2VybmFtZSI6InlvdXNzZWYiLCJpYXQiOjE3MDI1ODE1MzQsImV4cCI6MTcwMjU4ODczNH0.NHtHaPhmaAvh8de-60i_14OzGM-bIW6GI9AoN6pcSaE"
    
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
    
    
    func getAllParticipations() async {
        do {
            let participations = try await ParticipationWebService.shared.getAllByUser(token: token)
            DispatchQueue.main.async {
                self.participations = participations
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
