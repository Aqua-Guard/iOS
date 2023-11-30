//
//  PostListView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import SwiftUI

struct PostListView: View {
  
    @EnvironmentObject var postViewModel : PostViewModel
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(postViewModel.posts,id: \.id){post in
                        PostCardView(post: post) // it show me alway the first post1
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .padding(.vertical)
                        
                    }.listStyle(PlainListStyle())
                        .navigationTitle("Forum")
                        .padding()
                        
                        
                }
            }
            
        }
        
    }
}

#Preview {
    PostListView().environmentObject(PostViewModel())
}
