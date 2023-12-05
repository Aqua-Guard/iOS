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
    
    func isParticipated(eventId: String, token: String) async throws -> Bool {
        // Define the API endpoint URL with the eventId as a query parameter
        let apiUrlString = "\(baseURL)/participations/participate/\(eventId)"
        
        // Create the URL
        guard let url = URL(string: apiUrlString) else {
            throw URLError(.badURL)
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add the token to the request header

        // Perform the request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check for a successful HTTP response
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                // User is not participating (status code 404)
                return false
            } else {
                // Other status codes indicate an error
                throw URLError(.badServerResponse)
            }
        }
        
        // User is participating
        return true
    }


    

    
}
