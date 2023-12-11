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
                        .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                    VStack {
                        TextInputField("Username", text: $modelView.username, error: $modelView.usernameError)
                        //.padding(.top)
                        
                        
                        
                        PasswordInputField("Password", text: $modelView.password, error: $modelView.passwordError)
                        Spacer()
                        
                        Button(action: {
                            self.modelView.validate()
                            Task {
                                await modelView.login()
                                /*NavigationLink(destination: ContentView(), isActive: $modelView.loggingIn) {
                                    
                                }*/
                            }
                        }, label: {
                            NavigationLink(destination: ContentView(), isActive: $modelView.loggingIn) {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                                    .frame(width: screenWidth * 0.91, height: screenWidth * 0.13)
                            }
                            
                        })
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

#Preview {
    LoginView()
}
