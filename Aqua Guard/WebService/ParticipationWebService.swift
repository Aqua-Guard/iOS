//
//  ParticipationWebService.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 5/12/2023.
//

import Foundation
final class ParticipationWebService {
    static let shared = ParticipationWebService()
    private let baseURL = "http://192.168.43.253:9090"
    
    func addParticipation(eventId: String, token: String) {
        // Define the API endpoint URL with the eventId as a query parameter
        let apiUrlString = "\(baseURL)/participations/participate/\(eventId)"
        
        // Create the URL
        guard let url = URL(string: apiUrlString) else {
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add the token to the request header

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error adding participation: \(error)")
                return
            }
           
        }.resume()
    }
    
    
    
    func deleteParticipation(eventId: String, token: String) {
        // Define the API endpoint URL with the eventId as a query parameter
        let apiUrlString = "\(baseURL)/participations/participate/\(eventId)"
        
        // Create the URL
        guard let url = URL(string: apiUrlString) else {
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add the token to the request header

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error deleting participation: \(error)")
                return
            }
           
        }.resume()
    }

    
}
