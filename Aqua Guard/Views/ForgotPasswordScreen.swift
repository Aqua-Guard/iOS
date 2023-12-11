//
//  ResetPasswordScrren.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import SwiftUI

struct ForgotPasswordScreen: View {
    var screenWidth = UIScreen.main.bounds.width
    @State var textValue: String = ""
    @State var errorValue: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image("reset_password")
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom)
                    
                }
                .padding(.top)
                .frame(width: screenWidth)
                //Spacer()
                VStack {
                    VStack {
                        
                        Text("Type your new password")
                            .font(.system(size: 20))
                            .fontWeight (.semibold)
                            .foregroundColor(.lightBlue)
                            .padding(.all)
                        
                        TextInputField("Password", text: $textValue, error: $errorValue)
                            .padding(.bottom)
                        
                        TextInputField("Confirm password", text: $textValue, error: $errorValue)
                            .padding(.bottom)
                        
                        //Spacer()
                            Button(action: {
                               
                            }, label: {
                                Text ("Reset Password")
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
    ForgotPasswordScreen()
}
