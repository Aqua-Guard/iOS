//
//  LoginViewModel.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import Foundation
import LocalAuthentication
import SwiftUI

class LoginViewModell: ObservableObject {
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var usernameError:String = ""
    @Published var passwordError:String = ""
    @Published private(set) var error: String?
    @Published var loggingIn: Bool = false
    let emailValidationRegex = "^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,7})+$"

    func login() async {

        var json = [String:Any]()
        json["username"] = username
        json["password"] = password
        
        print(username);
        print(password);
        
        do {
            
            await MainActor.run {
                self.loggingIn = true
                ContentView()
            }
            
        let (responseData, response) = try await UserService.makeRequest(endpoint: "/login", method: "POST", body: json)

            
            let httpResponse = (response as? HTTPURLResponse)
        
        if(type(of: httpResponse!) != HTTPURLResponse.self){
            await MainActor.run {
                self.error = "Unexpected error!"
                self.loggingIn = false

            }
        }
        
        if (httpResponse!.statusCode == 200) {
            if (try? JSONDecoder().decode(LoginResponse.self, from: responseData)) != nil {
                await MainActor.run {
                self.error = ""
                self.loggingIn = false
                }
                                
            }
        }
        else {
            await MainActor.run {
                self.error = "Invalid Credentials!"
                self.loggingIn = false
                }
            }
                        
        }
        catch {
            await MainActor.run {
                self.error = "Unexpected error!"
                self.loggingIn = false
            }
        }
        
    }
    
    func validate() {
        if (username == ""){
            usernameError = "This field is required!"
        }
        else {
            usernameError = ""
        }
        
        if (password == ""){
            passwordError = "This field is required!"
        }
        else {
            passwordError = ""
        }
    }
}
