//
//  PostDetailView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 30/11/2023.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @State private var isLiked = false
    @State private var likeCount: Int = 0
    @State private var commentText: String = ""
    @State var showingLikeBottomSeet = false
    @State var showingCommentBottomSeet = false
    init(post: Post) {
        self.post = post
        // Initialize the likeCount state with the initial like count of the post
        _likeCount = State(initialValue: post.nbLike)
    }
    
    var body: some View {
        let commentCount: Int = post.nbComments
        
        // MaterialCardView equivalent in SwiftUI is a VStack inside a RoundedRectangle
        VStack(alignment: .leading) {
            // User info and post image
            HStack {
                // User image
                Image(post.userImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.darkBlue, lineWidth: 2))
                
                // User name and role
                VStack(alignment: .leading, spacing: 8) {
                    Text(post.userName)
                        .font(.title2)
                    Text(post.userRole)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(16)
                // i want to add 3cirlcle like option  "..."
                
            }
            
            Divider()
                .background(Color.darkBlue)
            
            // Post description
            Text(post.description)
                .padding(16)
                .foregroundColor(.secondary)
            
            //  i want ti center this image
            Image(post.postImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom)
            Divider()
                .background(Color.darkBlue)
            
            
            HStack {
                // Like icon with label and count
                
                Button(action: {
                    showingLikeBottomSeet.toggle()
                })
                {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .pink : .pink)
                    Text("Like \(post.nbLike)")
                        .foregroundStyle(Color.black)
                }
                .padding(.trailing, -6)
                .sheet(isPresented: $showingLikeBottomSeet){
                    LikeBottomSheetView(likes: post.likes)
                        .presentationDetents([.medium,.large])
                    
                }
                
                // this don't want to chage their
                Spacer()
                Button(action: {
                    showingCommentBottomSeet.toggle()
                }) {
                    Image(systemName: commentCount > 0 ? "text.bubble.fill" : "text.bubble")
                        .foregroundColor(commentCount > 0 ? .yellow : .yellow )
                        .padding(.trailing, -6)
                    Text("Comment \(commentCount)")
                        .foregroundStyle(Color.black)
                } .sheet(isPresented: $showingCommentBottomSeet){
                    CommentBottomSheetView(comments: post.comments)
                        .presentationDetents([.medium,.large])
                }
                Spacer()
                
                
                // Share icon with label and count
                Image(systemName: "square.and.arrow.up") .foregroundColor(Color("babyBlue"))
                    .padding(.trailing, -6)
                Text("Share 0")
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            
            
            
            
            
            
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(10)
        .navigationBarTitle("Post Details").navigationBarTitleDisplayMode(.inline)
    }
    
    
}
struct LikeBottomSheetView: View {
    let likes: [Like]
    
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.pink)
            
            
            Text("Post liked by ")
                .font(.title)
                .foregroundColor(Color.black) +
            Text("\(likes.count) ")
                .font(.title)
                .bold()
                .foregroundColor(Color.pink) +
            Text(" people").font(.title)
                .foregroundColor(Color.black)
            
            
            // Display like card views if there are likes
            if likes.count > 0 {
                ForEach(likes, id: \.id) { like in // Assuming 'Like' has an 'id' property
                    LikeCardView(like: like)
                }
            } else {
                Image("heartbroke_amico_pink")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .aspectRatio(contentMode: .fit)
                Text("No Likes")
                    .foregroundColor(Color.pink)
                    .font(.title)
            }
        }
        //.padding(.top,2)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct CommentBottomSheetView: View {
    let comments: [Comment]
    
    
    var body: some View {
        VStack {
            Image(systemName: "text.bubble.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
            
            Text("Post commented by \(comments.count) people")
                .font(.title)
                .foregroundColor(.black)
            
            if comments.count > 0 {
                List {
                    ForEach(comments) { comment in
                        CommentCardView(comment: comment)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button(role: .cancel) {
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }.tint(.blue)
                            }
                    }
                }
                .listStyle(PlainListStyle())
            } else {
                Spacer()
                Text("No Comment")
                    .foregroundColor(.orange)
                    .font(.title)
                Spacer()
            }
        }
        .padding()
        // nothing epear
        .background(
            Image("splashScreenImage") // Use your splash screen image name here
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .cornerRadius(10)
        .shadow(radius: 2)
        // nothing epear as title
        .navigationBarTitle("Post Details").navigationBarTitleDisplayMode(.inline)
    }
    
    
}

#Preview {
    PostDetailView(post: post1)
}
