//
//  MyPosts.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 28/11/2023.
//

import SwiftUI

struct MyPosts: View {
    var posts : [Post] = PostList.postList
    
    var body: some View {
        NavigationView{
            List(posts,id: \.id){post in
                PostCardView(post: post) // it show me alway the first post1
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.vertical)
                    
            }
            .navigationTitle("My Posts")
            .frame(width: UIScreen.main.bounds.width)
        }
        
    }
}

#Preview {
    MyPosts()
}
