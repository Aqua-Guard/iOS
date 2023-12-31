//
//  ConversationWebService.swift
//  Aqua Guard
//
//  Created by Mac Mini 5 on 15/12/2023.
//

import Foundation



final class ConversationWebService{
    
    static let shared = ConversationWebService()
    private let baseURL = "http://192.168.93.190:9090"
    
    
    
    static func sendmessage(message: String, userRole: String, reclamationid: String) async throws -> Bool {
        let boundary = "Boundary-\(UUID().uuidString)"
        var id = "6555d5c10f8bb38893f5be50"
        var request = URLRequest(url: URL(string: "http://192.168.93.190:9090/discution")!)
        request.httpMethod = "POST"
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
    
    
 
    
    func fetchDiscussions(reclamationId: String, completion: @escaping ([Discussion]?) -> Void) {
            let url = URL(string: "\(baseURL)/reclamation/getdiscution")!
            let boundary = "Boundary-\(UUID().uuidString)"

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        // iduser part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"reclamationId\"\r\n\r\n")
        body.append("\(reclamationId)\r\n")
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        
            // Set the request body with the reclamationId
          
            do {
                request.httpBody = body
            } catch let error {
                print("Error serializing request body:", error)
                completion(nil)
                return
            }
            
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
                    let discussions = jsonArray.compactMap {
                        Discussion(json: $0)
                    }
                    print("discussions---------------")
                    print(discussions)
                    completion(discussions)
                } else {
                    completion(nil)
                }
            } catch let error {
                print("*****Discussion fetching failed with error: \(error)")
                completion(nil)
            }
        }.resume()
    }

    
    
    
    
    
    
    
    
}
