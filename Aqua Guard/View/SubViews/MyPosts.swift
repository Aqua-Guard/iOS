//
//  My Posts.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 27/11/2023.
//

import SwiftUI

struct MyPosts: View {
    var body: some View {
        NavigationView{
            ZStack {
                           // Background image
                           Image("background_splash_screen")
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .edgesIgnoringSafeArea(.all)
                           
                           // Your content here
                           Text("My Posts")
                .navigationTitle("MyPosts")                       }
        }
    }
}

#Preview {
    MyPosts()
}

