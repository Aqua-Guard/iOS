//
//  Network.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import Foundation

let URLString:String = "http://192.168.1.13:9090"







extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
    
class NetworkManager {
    
    public static func makeRequest(endpoint:String, method:String, body:[String:Any]?) async throws -> (Data, URLResponse) {
        
        var responseData:Data?, response:URLResponse
        
        // server endpoint
        let url = URLString+endpoint
        let endpointUrl = URL(string: url)
        var request = URLRequest(url: endpointUrl!)
        
        
        if(method != "GET" && method != "DELETE"){
            var data: Data?
            if(body != nil){
                data = try? JSONSerialization.data(withJSONObject: body!, options: [])
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            (responseData, response) = try await URLSession.shared.upload(
                for: request,
                from: data!
            )
        }
        else {
            (responseData, response) = try await URLSession.shared.data(for: request)
        }
        
        
        return (responseData!, response)
    }
}
