//
//  Command.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 28/11/2023.
//

import SwiftUI

struct Command: View {
    var body: some View {
        NavigationView{
            ZStack {
                           // Background image
                           Image("background_splash_screen")
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .edgesIgnoringSafeArea(.all)
                           
                           // Your content here
                           Text("My Command")
                .navigationTitle("My Command")                       }
        }    }
}

#Preview {
    Command()
}
