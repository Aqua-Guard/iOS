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
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image("forgot_password2")
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom)
                    
                }
                .padding(.top)
                .frame(width: screenWidth)
                Spacer()
                VStack {
                    VStack {
                        TextInputField("Email", text: $textValue, error: $errorValue)
                            .padding(.bottom)
                        
                        Spacer()
                        
                        
                            //Button(action: {
                               
                            //}, label: {
                        NavigationLink(destination: ForgotPaswordCodeScreen()) {
                            Text ("Send Code")
                                .foregroundColor (.white)
                                .fontWeight (.semibold)
                                .font(.system(size:22))
                                .frame(minWidth: 0, maxWidth: .infinity)
                            
                            .frame(width: screenWidth * 0.91, height: screenWidth * 0.13)
                        }
                            //}
                                
                            //)
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
    ForgotPasswordEmailScreen()
}
