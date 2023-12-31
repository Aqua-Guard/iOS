//
//  RegisterViewModel.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 12/6/23.
//

import Foundation

class RegisterViewModel : ObservableObject {
    @Published var firstName:String = ""
    @Published var lastName:String = ""
    @Published var email:String = ""
    @Published var image:Data!
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var confirmPassword:String = ""
    @Published var firstNameError:String = ""
    @Published var lastNameError:String = ""
    @Published var emailError:String = ""
    @Published var usernameError:String = ""
    @Published var passwordError:String = ""
    @Published var confirmPasswordError:String = ""
    @Published var isLoading: Bool = false
    @Published var reqError: String = ""
    let userService = UserService()

    
    func register(email: String, firstName: String, lastName: String, image: Data, username: String, password: String) async {
        if let imageURL = URL(string: image.base64EncodedString()) {
            let User = UsersModel(id: UUID().uuidString, email: email, firstName: firstName, lastName: lastName, username: username, password: password, image: imageURL.path())
            
            do {
                try await userService.register(user: User, image: image)
                
            } catch {
                print("Error creating account: \(error)")
            }

        } else {
            print("Invalid image URL")
        }
    }
    
    func signup() async {

        if(usernameError == "" && passwordError == "" && confirmPasswordError == "" && emailError == "" && lastNameError == "" && firstNameError == ""){
            await MainActor.run {
                self.isLoading = true
            }
            do {
                var json = [String:Any]()
                json["email"] = email
                json["username"] = username
                json["password"] = password
                json["firstName"] = firstName
                json["lastName"] = lastName
                //json["image"] = image.base64EncodedString()

                print("amira");
                //print(image.base64EncodedString());


                let (responseData, response) = try await UserService.makeRequest(endpoint: "/registerAndroidIOS", method: "POST", body: json)
                let httpResponse = (response as? HTTPURLResponse)
                
                if(type(of: httpResponse!) != HTTPURLResponse.self){
                    
                    await MainActor.run {
                        self.reqError = "Unexpected error!"
                        self.isLoading = false
                    }
                }
                
                if(httpResponse?.statusCode == 201) {
                    
                      print("done")
                    
                }
                else {
                   print("user not created")
                }
                
            }
            catch {
                await MainActor.run {
                    self.reqError = "Unexpected error!"
                    self.isLoading = false
                }
            }
        }
    }
    
    
    
    
    func isValidPass(strToValidate: String) -> Bool {
        let passValidationRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[\\W_])[A-Za-z\\d\\W_]{8,}$"
        let passValidationPredicate = NSPredicate(format: "SELF MATCHES %@", passValidationRegex)
        return passValidationPredicate.evaluate(with: strToValidate)
    }
    
    func isValidEmailAddr(strToValidate: String) -> Bool {
        let emailValidationRegex = "^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,7})+$"
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        return emailValidationPredicate.evaluate(with: strToValidate)
    }
    
    func validate() {

        if (firstName == ""){
            firstNameError = "This field is required!"
        }
        else if (firstName.rangeOfCharacter(from: .decimalDigits) != nil) {
            firstNameError = "This field can only contain letters!"
        }
        else {
            firstNameError = ""
        }
        
        if (lastName == ""){
            lastNameError = "This field is required!"
        }
        else if (lastName.rangeOfCharacter(from: .decimalDigits) != nil) {
            lastNameError = "This field can only contain letters!"
        }
        else {
            lastNameError = ""
        }
        
        if (username == ""){
            usernameError = "This field is required!"
        } else {
            usernameError = ""
        }
        
        if (email == ""){
            emailError = "This field is required!"
        } else if (!isValidEmailAddr(strToValidate: email)){
            emailError = "Invalid email!"
        }
        else {
            emailError = ""
        }
        
        if(password == "" || confirmPassword == ""){
            passwordError = password == "" ? "This field is required!" : ""
            confirmPasswordError = confirmPassword == "" ? "This field is required!" : ""
        }/* else if (!isValidPass(strToValidate: password)){
            passwordError = "Password should be at least eight characters and have at least one letter, one number and one special character!"
            confirmPasswordError = ""
        } */else if(password != confirmPassword){
            confirmPasswordError = "Passwords do not match!"
            passwordError = ""
        } else {
            confirmPasswordError = ""
            passwordError = ""
        }
    }
}
