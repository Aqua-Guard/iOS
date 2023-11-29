//
//  PostListView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import SwiftUI

struct PostListView: View {
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
            .navigationTitle("Forum")
            .frame(width: UIScreen.main.bounds.width)
        }    }
}

#Preview {
    PostListView()
}
