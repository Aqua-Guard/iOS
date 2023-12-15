//
//  changePassword.swift
//  Aqua Guard
//
//  Created by Mac Mini 1 on 15/12/2023.
//

import SwiftUI

struct changePassword: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State var isDarkModeEnabled: Bool = false
    @State var emailNotif: Bool = false
    @State private var deleteAlert = false
    let userImage = LoginViewModell.defaults.string(forKey: "image")
    @StateObject var viewModel: UserViewModel = UserViewModel()
    @State private var navigationActive: Bool = false

    var body: some View {
        ScrollView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [isDarkModeEnabled ? Color.black : Color.white, isDarkModeEnabled ? Color.lightBlue : Color.lightBlue]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("reset_password")
                        .resizable()
                        .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                        .padding(.bottom)
                    
                    VStack{
                        VStack {
                            
                            Text("Type your new password")
                                .font(.system(size: 20))
                                .fontWeight (.semibold)
                                .foregroundColor(.lightBlue)
                                .padding(.all)
                            
                            TextInputField("Old Password", text: $viewModel.oldPassword, error: $viewModel.error)
                                .padding(.bottom)
                            
                            TextInputField("New Password", text: $viewModel.newPassword, error: $viewModel.error)
                                .padding(.bottom)
                            
                            TextInputField("Confirm password", text: $viewModel.confirmPassword, error: $viewModel.error)
                                .padding(.bottom)
                            
                            //Spacer()
                            
                            ZStack {
                                NavigationLink(
                                    destination: SettingsView(),
                                    isActive: $navigationActive
                                ) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                Button(action: {
                                    Task {
                                        await self.viewModel.changePassword()
                                        
                                        if self.viewModel.changed {
                                            navigationActive = true
                                        }
                                    }
                                }) {
                                    Text ("Change Password")
                                        .foregroundColor (.white)
                                        .fontWeight (.semibold)
                                        .font(.system(size:22))
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(width: screenWidth * 0.88, height: screenWidth * 0.13)
                                }
                            }
                            
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle)
                            .tint(Color.blue)
                            .cornerRadius(30)
                            .padding(.horizontal)
                        }
                        
                    }
                    .listStyle(PlainListStyle())
                }.accentColor(.white)
            }
        }
        .navigationBarColor(.darkBlue, textColor: UIColor.white)
    
        
        
        
    }
}

#Preview {
    changePassword()
}
