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
                    if let posts = postViewModel.posts, !posts.isEmpty {
                        // Display the list of posts
                        ForEach(postViewModel.posts ?? [], id: \.idPost) { post in
                            MySinglePostView(viewModel: postViewModel, post: post)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 4)
                        }
                    } else {
                        // Display error message and image
                        VStack {
                            Image(systemName: "exclamationmark.triangle") // Your error image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.red)
                            Text("No Post")
                                .padding()
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("My Posts")
                .navigationBarTitleDisplayMode(.inline)
            

                
                
            }
            .background(
                Image("background_splash_screen")
                  
                    .scaledToFill() // Fill the space without distorting aspect ratio
                    .edgesIgnoringSafeArea(.all) // Ignore safe area to extend to edges
            )
            .onAppear{
                Task{
                    await postViewModel.getMyPosts()
                }
            }
            
        }
        
    }
    
}

#Preview {
    
    
    MyPosts().environmentObject(PostViewModel())
}
