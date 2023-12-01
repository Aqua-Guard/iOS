//
//  ResetPasswordScrren.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import SwiftUI

struct ResetPasswordScreen: View {
    var screenWidth = UIScreen.main.bounds.width
    @State var textValue: String = ""
    @State var errorValue: String = ""
    

    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Image("reset_password")
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom)
                    
                }
                .padding(.top)
                .frame(width: screenWidth)
                Spacer()
                VStack {
                    VStack {
                        TextInputField("Password", text: $textValue, error: $errorValue)
                            .padding(.bottom)
                        
                        TextInputField("Confirm password", text: $textValue, error: $errorValue)
                            .padding(.bottom)
                        
                        Spacer()
                            Button(action: {
                               
                            }, label: {
                                Text ("Reset Password")
                                    .foregroundColor (.white)
                                    .fontWeight (.semibold)
                                    .font(.system(size:22))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                
                                .frame(width: screenWidth * 0.91, height: screenWidth * 0.13)
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
        }//.background(Color.halfLnearBG.ignoresSafeArea())
    }
}

#Preview {
    ResetPasswordScreen()
}
