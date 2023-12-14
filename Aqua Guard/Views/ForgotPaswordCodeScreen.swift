//
//  ResetPaswordCodeScreen.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/30/23.
//

import SwiftUI

struct ForgotPaswordCodeScreen: View {
    var screenWidth = UIScreen.main.bounds.width
    @State var textValue: String = ""
    @State var errorValue: String = ""
    @StateObject var viewModel: UserViewModel = UserViewModel()

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image("activation_code")
                        .aspectRatio(contentMode: .fit)
                        .padding(.all)
                    
                }
                .padding(.all)
                .frame(width: screenWidth)
                //Spacer()
                VStack {
                    VStack {
                        
                        
                        Text("Write your code below")
                            .font(.system(size: 20))
                            .fontWeight (.semibold)
                            .foregroundColor(.lightBlue)
                            .padding(.all)
                        
                        TextInputField("Code", text: $viewModel.code, error: $viewModel.error)
                            .padding(.bottom)
                        
                        //Spacer()
                            Button(action: {
                               
                            }, label: {
                        NavigationLink(destination: ForgotPasswordScreen()) {
                            Text ("Reset Password")
                                .foregroundColor (.white)
                                .fontWeight (.semibold)
                                .font(.system(size:22))
                                .frame(minWidth: 0, maxWidth: .infinity)
                            
                                .frame(width: screenWidth * 0.88, height: screenWidth * 0.13)
                        }
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
    ForgotPaswordCodeScreen()
}
