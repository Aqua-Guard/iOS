//
//  UserService.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 5/12/2023.
//

import Foundation

let URLString:String = "http://172.18.24.87:9090/user"


class UserService{
    public static func makeRequest(endpoint:String, method:String, body:[String:Any]?) async throws -> (Data, URLResponse) {
        
        var responseData:Data?, response:URLResponse
        
        let url = URLString+endpoint
        let endpointUrl = URL(string: url)
        var request = URLRequest(url: endpointUrl!)
        
        request.httpMethod = method
        
        if(method != "GET" && method != "DELETE"){
            var data: Data?
            if(body != nil){
                data = try? JSONSerialization.data(withJSONObject: body!, options: [])
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            /*
            (responseData, response) = try await URLSession.shared.upload(
                for: request,
                from: data!
            )*/
            
            do {
                (responseData, response) = try await URLSession.shared.upload(for: request,from: data!)
            } catch {
                throw error
            }
        }
        else {
            (responseData, response) = try await URLSession.shared.data(for: request)
        }
        
        
        return (responseData!, response)
    }
    
    public static func RegisterRequest(endpoint:String, method:String, body:[String:Any]?, image: Data) async throws -> (Data, URLResponse) {
        
        var responseData:Data?, response:URLResponse
        
        let url = URLString+endpoint
        let endpointUrl = URL(string: url)
        var request = URLRequest(url: endpointUrl!)
        
        request.httpMethod = method
        
        if(method != "GET" && method != "DELETE"){
            var data: Data?
            if(body != nil){
                data = try? JSONSerialization.data(withJSONObject: body!, options: [])
            }
            
            let boundary = "Boundary-\(UUID().uuidString)"

            var request = URLRequest(url: endpointUrl!)
                    request.httpMethod = "POST"
                    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var httpBody = NSMutableData()

            httpBody.append(convertFileData(fieldName: "image",
                                            fileName: "image",
                                            mimeType: "image/jpeg",
                                            fileData: image,
                                            using: boundary))

            
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

func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
    let data = NSMutableData()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
    data.appendString("Content-Type: \(mimeType)\r\n\r\n")
    data.append(fileData)
    data.appendString("\r\n")
    
    return data as Data
}
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }


extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
