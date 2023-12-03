//
//  RegisterView.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/29/23.
//

import SwiftUI

struct RegisterView: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State var textValue: String = ""
    @State var errorValue: String = ""
    @State private var isActive = false

    var body: some View {
        NavigationView {
            
            ZStack{
                Image("login_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: screenWidth * 1, height: screenWidth * 1)
                
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: screenWidth * 0.6, height: screenWidth * 0.6)
                    VStack {
                        TextInputField("Email", text: $textValue, error: $errorValue)
                        TextInputField("Username", text: $textValue, error: $errorValue)
                        TextInputField("First name", text: $textValue, error: $errorValue)
                        TextInputField("Last name", text: $textValue, error: $errorValue)
                        
                        PasswordInputField("Password", text: $textValue, error: $errorValue)
                        PasswordInputField("Confirm password", text: $textValue, error: $errorValue)
                        //Spacer()
                        Button(action: {
                        }, label: {
                            Text("Sign in")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .frame(width: screenWidth * 0.91, height: screenWidth * 0.13)
                        })
                        .background(Color.lightBlue)
                        .cornerRadius(30)
                        .padding(.top)
                    }
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 20))
                            .foregroundColor(Color.black)

                            NavigationLink(destination: LoginView()) {
                            Text("Sign in")
                                .font(.system(size: 20))
                                .foregroundColor(Color.lightBlue)
                            }

                    }
                    .padding(.bottom)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterView()
}
