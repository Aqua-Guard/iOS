//
//  MyPosts.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 28/11/2023.
//

import SwiftUI

struct MyPosts: View {
    @EnvironmentObject var postViewModel : PostViewModel
    var body: some View {
        
        NavigationView{
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(postViewModel.posts,id: \.id){post in
                        PostCardView(post: post) // it show me alway the first post1
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 4)
                        
                    }.listStyle(PlainListStyle())
                        .navigationTitle("My Posts")
                        .padding()
                }
                .background(
                    Image("background_splash_screen") // Replace with your image name
                        .resizable() // Make the image resizable
                        .scaledToFill() // Fill the space without distorting aspect ratio
                        .edgesIgnoringSafeArea(.all) // Ignore safe area to extend to edges
                )
                
                
            }
            
        }
        
    }
    
}

#Preview {
    
    MyPosts()
        .environmentObject(PostViewModel())
}
