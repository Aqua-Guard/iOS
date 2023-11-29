//
//  MyEvents.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 28/11/2023.
//

import SwiftUI

struct MyEvents: View {
    var body: some View {
        NavigationView{
            ZStack {
                
                // Background image
                Image("background_splash_screen")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                Text("")
                    .navigationTitle("My Events")
                
            }
        }
    }
}

#Preview {
    MyEvents()
}
