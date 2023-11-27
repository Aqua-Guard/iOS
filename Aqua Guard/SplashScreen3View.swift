//
//  SplashScreen3View.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

struct SplashScreen3View: View {
    var body: some View {
        ZStack {
            Image("background_splash_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                Image("image_sp3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                
                Text("Receive alerts and tips for responsible water use.")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
         
                
                HStack {
                    RadioButton(selected: false)
                    RadioButton(selected: false)
                    RadioButton(selected: true)
                }
                .padding(.top, 20)
                Spacer()
                
                HStack {
                    Button(action: {
                        // Handle button tap for Skip
                    }) {
                        Text("Skip")
                            .font(.system(size: 20))
                            .foregroundColor(.blue) // Set your color
                    }
                    .padding(.leading,300) // Adjust as needed
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    SplashScreen3View()
}
