//
//  ReclamationWebService.swift
//  Aqua Guard
//
//  Created by Mac Mini 5 on 14/12/2023.
//

import Foundation

final class ReclamationWebService{
    static let shared = ReclamationWebService()
    private let baseURL = "https://aquaguard-tux1.onrender.com"
    
    
    
    static func AddReclamation(token : String ,userId : String ,title: String, description: String, imageData: Data) async throws -> Bool {
        let boundary = "Boundary-\(UUID().uuidString)"
       
        var request = URLRequest(url: URL(string: "https://aquaguard-tux1.onrender.com/reclamation")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        // iduser part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"userId\"\r\n\r\n")
        body.append("\(userId)\r\n")
        
        // title part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n")
        body.append("\(title)\r\n")
        
        // Description part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"desc\"\r\n\r\n")
        body.append("\(description)\r\n")
        

        
 
//
        // Image part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        
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
    
    
    
    
    
    func fetchreclamation(token : String , completion: @escaping ([Reclamation]?) -> Void) {
        let url = URL(string: "\(baseURL)/reclamation/getbyuserId")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching reclamation:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("jsonArray-----------")
                    print(jsonArray)
                    let reclamation = jsonArray.compactMap {
                        Reclamation(json: $0) }
                    print("reclamation---------------")
                    print(reclamation)
                    completion(reclamation)
                } else {
                    completion(nil)
                }
            } catch let error{
                print("*****reclamation fetching failed with error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    
    
    
    
    
    
    
}
