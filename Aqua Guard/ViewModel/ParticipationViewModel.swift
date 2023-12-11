//
//  ParticipationViewModel.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 5/12/2023.
//

import Foundation
class ParticipationViewModel: ObservableObject {
    
    @Published var participations: [Participation] = []
    
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTRkZjE4YjUzNWVjMDRlZmVkYWJiMGIiLCJ1c2VybmFtZSI6Im1hbGVrIiwiaWF0IjoxNzAyMzE5NjgzLCJleHAiOjE3MDIzMjY4ODN9.gbQQ2oFFn6P-xdCQrf3XgOvA0zyogQV0KkejLBHCG8c"
    
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
