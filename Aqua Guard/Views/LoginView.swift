//
//  LoginView.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/29/23.
//

import SwiftUI


struct LoginView: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @StateObject var modelView: LoginViewModell = LoginViewModell()
    @State var textValue: String = ""
    @State var errorValue: String = ""
    @State private var isActive = false
    @State private var navigationActive: Bool = false

    
    var body: some View {
        NavigationView {
            
            ZStack{
                Image("login_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: screenWidth * 1, height: screenWidth * 1)
                
                
                    ScrollView{
                        VStack {
                        
                        Image("logo")
                            .resizable()
                            .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                        VStack {
                            TextInputField("Username", text: $modelView.username, error: $modelView.usernameError)
                            
                            
                            PasswordInputField("Password", text: $modelView.password, error: $modelView.passwordError)
                            Spacer()
                            
                            ZStack {
                                NavigationLink(
                                    destination: ContentView(),
                                    isActive: $navigationActive
                                ) {
                                    EmptyView()
                                }
                                .opacity(0) // Hide the NavigationLink by setting opacity to 0
                                
                                Button(action: {
                                    self.modelView.validate()
                                    Task {
                                        print("amiraaaa")
                                        await self.modelView.login()
                                        
                                        // Activate the NavigationLink after successful login
                                        if self.modelView.loggingIn {
                                            // Use isActive to trigger the NavigationLink
                                            navigationActive = true
                                        }
                                    }
                                }) {
                                    if self.modelView.loggingIn {
                                        ProgressView()
                                    } else {
                                        Text("Login")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 20))
                                            .frame(width: screenWidth * 0.91, height: screenWidth * 0.13)
                                    }
                                }
                            }
                            .navigationBarHidden(true)
                            .background(Color.lightBlue)
                            .cornerRadius(30)
                            .padding(.top)
                            
                            
                            //Button(action: {
                            
                            //}){
                            NavigationLink(destination: ForgotPasswordEmailScreen()){
                                Text("Forgot password?")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.lightBlue)
                                //
                            }
                            .padding(.top)
                            
                            HStack {
                                Text("- Or Sign in with -")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black)
                                
                            }
                            .padding(.all)
                            HStack {
                                Button(action: {
                                    
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(.white)
                                            .frame(width: screenWidth * 0.17, height: screenWidth * 0.17)
                                        Image("google")
                                            .resizable()
                                            .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
                                    }
                                }
                                Button(action: {
                                    
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(.blue)
                                            .frame(width: screenWidth * 0.17, height: screenWidth * 0.17)
                                        Image("facebook")
                                            .resizable()
                                            .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.all)
                            
                            HStack {
                                Text("Don’t have an account?")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.black)
                                
                                NavigationLink(destination: RegisterView()) {
                                    Text("Sign up")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.lightBlue)
                                }
                                
                            }
                            .padding(.bottom)
                        }
                    }
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    LoginView()
}
