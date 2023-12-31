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
    @State private var showAlert = false

    
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
                        
                        ZStack {
                                    NavigationLink(
                                        destination: ContentView(),
                                        isActive: $navigationActive
                                    ) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    
                                    Button(action: {
                                        self.modelView.validate()
                                        Task {
                                            print("amiraaaa")
                                            await self.modelView.login()
                                            
                                            if self.modelView.loggingIn {
                                                navigationActive = true
                                            } else {
                                                showAlert = true
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
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Login Failed"),
                                        message: Text("Your login attempt was unsuccessful."),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                        
                        NavigationLink(destination: ForgotPasswordEmailScreen()){
                        Text("Forgot password?")
                            .font(.system(size: 20))
                            .foregroundColor(Color.lightBlue)
                        
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
