//
//  SplashScreen1View.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

import SwiftUI

struct SplashScreen1View: View {
    var body: some View {
        ZStack {
            Image("background_splash_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                Image("image_sp_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                
                Text("Explore the beauty and diversity of aquatic life with AquaGuard.")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
         
                
                HStack {
                    RadioButton(selected: true)
                    RadioButton(selected: false)
                    RadioButton(selected: false)
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



struct RadioButton: View {
    var selected: Bool
    
    var body: some View {
        Image(systemName: selected ? "largecircle.fill.circle" : "circle")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.blue) // Set your color
            .onTapGesture {
                // Handle radio button tap
            }
    }
}




#Preview {
    SplashScreen1View()
}
