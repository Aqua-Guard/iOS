//
//  SplashScreenView.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        if isActive{
            LoginView()
        }
        else{
            ZStack {
                Image("background_splash_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: screenWidth * 1.11, height: screenWidth * 1)
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                }
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.isActive = true
                }
            }
        }
    }
}


struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}


