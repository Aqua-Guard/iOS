//
//  ResetPasswordEmailScreen.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import SwiftUI

struct ForgotPasswordEmailScreen: View {
    var screenWidth = UIScreen.main.bounds.width
    @State var textValue: String = ""
    @State var errorValue: String = ""
    @StateObject var viewModel: UserViewModel = UserViewModel()

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image("forgot_password2")
                        .aspectRatio(contentMode: .fit)

                    
                }
                .padding(.all)
                .frame(width: screenWidth)
                //Spacer()
                VStack {
                    VStack {
                        
                        Text("Write your email here to receive a code")
                            .font(.system(size: 20))
                            .fontWeight (.semibold)
                            .foregroundColor(.lightBlue)
                            .padding(.all)

                        TextInputField("Email", text: $viewModel.email, error: $viewModel.error)
                            .padding(.bottom)
                        
                        //Spacer()
                        
                            Button(action: {
                                Task{
                                    await viewModel.sendEmail()
                                }
                            }, label: {
                            Text ("Send Code")
                                .foregroundColor (.white)
                                .fontWeight (.semibold)
                                .font(.system(size:22))
                                .frame(minWidth: 0, maxWidth: .infinity)
                            
                            .frame(width: screenWidth * 0.88, height: screenWidth * 0.13)
                        }
                                
                            )
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle)
                            .tint(Color.blue)
                            .cornerRadius(30)
                            .padding(.horizontal)
                            .background(
                                NavigationLink(destination: ForgotPaswordCodeScreen()) {
                                })
                    }
                    
                    
                }

            }
        }.background(
            Image("background_splash_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all))
    }
}
#Preview {
    ForgotPasswordEmailScreen()
}
