//
//  LoginViewModel.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import Foundation
import LocalAuthentication
import SwiftUI




class LoginViewModel: ObservableObject {
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var emailError:String = ""
    @Published var passwordError:String = ""
    @Published private(set) var error: String?
    @Published var loggingIn: Bool = false
    let emailValidationRegex = "^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,7})+$"
/*
    func login() async {

        var json = [String:Any]()
        json["email"] = email
        json["password"] = password
        
        do {
            
            await MainActor.run {
                self.loggingIn = true
            }
            
        let (responseData, response) = try await NetworkManager.makeRequest(endpoint: "/login", method: "POST", body: json)
        let httpResponse = (response as? HTTPURLResponse)
        
        if(type(of: httpResponse!) != HTTPURLResponse.self){
                            await MainActor.run {
                                self.error = "Unexpected error!"
                                self.loggingIn = false

                            }
                        }
        
        if (httpResponse!.statusCode == 200) {
                            if let decodedResponse = try? JSONDecoder().decode(LoginResponseModel.self, from: responseData) {
                                    await MainActor.run {
                                        self.error = ""
                                        self.loggingIn = false
                                    }
                                
                            }
                        }
                        else {
                            await MainActor.run {
                                self.error = "Invalid Credientials!"
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
        
    }*/
    
    func validate() {
        if (email == ""){
            emailError = "This field is required!"
        } else if (email == emailValidationRegex){
            emailError = "Invalid email!"
        }
        else {
            emailError = ""
        }
        
        if (password == ""){
            passwordError = "This field is required!"
        }
        else {
            passwordError = ""
        }
    }
}
