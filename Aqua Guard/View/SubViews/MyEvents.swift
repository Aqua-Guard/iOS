//
//  My Events.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 27/11/2023.
//

import SwiftUI

struct My_Events: View {
    var body: some View {
        NavigationView{
            ZStack {
                           // Background image
                           Image("background_splash_screen")
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .edgesIgnoringSafeArea(.all)
                           
                           // Your content here
                           Text("MY Events")
                .navigationTitle("My Events")                       }
        }
    
    }
}

#Preview {
    My_Events()
}
