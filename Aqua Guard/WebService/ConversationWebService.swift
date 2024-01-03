//
//  ConversationWebService.swift
//  Aqua Guard
//
//  Created by Mac Mini 5 on 15/12/2023.
//

import Foundation



final class ConversationWebService{
    
    static let shared = ConversationWebService()
    private let baseURL = "https://aquaguard-tux1.onrender.com"
    
    
    
    static func sendmessage(token : String,message: String, userRole: String, reclamationid: String) async throws -> Bool {
        let boundary = "Boundary-\(UUID().uuidString)"
       
        var request = URLRequest(url: URL(string: "https://aquaguard-tux1.onrender.com/discution")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        // iduser part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"reclamationId\"\r\n\r\n")
        body.append("\(reclamationid)\r\n")
        
        // title part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"userRole\"\r\n\r\n")
        body.append("\(userRole)\r\n")
        
        // Description part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"message\"\r\n\r\n")
        body.append("\(message)\r\n")
        
       
        // End boundary
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            // Handle server errors here
            throw URLError(.badServerResponse)
        }
        // Decode response if needed or just return true to indicate success
        return true
    }
    
    
 
    func fetchDiscussions(token: String, reclamationId: String, completion: @escaping ([Discussion]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/reclamation/getdiscution/\(reclamationId)") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Adjusted to GET, assuming it's a fetch operation
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching discussions:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("jsonArray-----------")
                    print(jsonArray)
                    let discussions = jsonArray.compactMap { Discussion(json: $0) }
                    print("discussions---------------")
                    print(discussions)
                    completion(discussions)
                } else {
                    print("Unable to parse JSON as array of dictionaries")
                    completion(nil)
                }
            } catch {
                print("*****Discussion fetching failed with error: \(error)")
                completion(nil)
            }
        }.resume()
    }

    
    
    
    
    
    
    
    
}
