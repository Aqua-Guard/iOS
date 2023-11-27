//
//  SplashScreen4View.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

struct SplashScreen4View: View {
    var body: some View {
        ZStack {
            Image("background_splash_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                Image("image_sp4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                
                Text("Sign in and be part of our community committed to a sustainable future.")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                    .frame(width: 298) // Adjust as needed
                
                HStack {
                    Button(action: {
                        // Handle button tap for Sign Up
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 20))
                            .foregroundColor(.lightBlue) // Set your color
                            .frame(width: 148, height: 60)
                            .background(.grey)
                            .cornerRadius(50)
                            .padding(.trailing, 0)
                    }

                    Button(action: {
                        // Handle button tap for Sign In
                    }) {
                        Text("Sign In")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            // Set your color
                            .frame(width: 148, height: 60)
                            .background(Color.lightBlue)
                            .cornerRadius(50)
                            .padding(.leading, 50)
                        
                    }
                }
                .padding(.top, 100)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SplashScreen4View()
}
