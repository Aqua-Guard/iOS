//
//  MyPosts.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 28/11/2023.
//

import SwiftUI

struct MyPosts: View {
    @ObservedObject var postViewModel = PostViewModel()
    var body: some View {
        
        NavigationView{
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(postViewModel.posts!.indices, id: \.self) { index in
                        PostCardView(viewModel: postViewModel, postIndex: index)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 4)
                    }.listStyle(PlainListStyle())
                        .navigationTitle("My Posts").navigationBarTitleDisplayMode(.inline)
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
