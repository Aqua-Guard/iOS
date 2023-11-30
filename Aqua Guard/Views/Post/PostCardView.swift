//
//  PostCardView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    @State private var isLiked = false
    @State private var likeCount: Int = 0
    @State private var commentText: String = ""
    init(post: Post) {
        self.post = post
        // Initialize the likeCount state with the initial like count of the post
        _likeCount = State(initialValue: post.nbLike)
    }
    
    
    var body: some View {
        let commentCount: Int = post.nbComments
        
        // MaterialCardView equivalent in SwiftUI is a VStack inside a RoundedRectangle
        VStack(alignment: .leading, spacing: 2) {
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
                Spacer()
                NavigationLink( destination: PostDetailView(post: post)) {
                    Image(systemName:"info.circle").foregroundColor(.blue)
                  
                }
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
                        // Toggle the isLiked state
                        self.isLiked.toggle()
                        if self.isLiked {
                            self.likeCount += 1
                        
                        } else {
                            self.likeCount -= 1
                        }
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .pink : .pink)
                        Text("Like \(self.likeCount)").foregroundStyle(Color.black)
                    }
                    .padding(.trailing, -6)
                    
                    
               
                
                // this don't want to chage their
                Spacer()
                
                Image(systemName: commentCount > 0 ? "text.bubble.fill" : "text.bubble")
                    .foregroundColor(commentCount > 0 ? .yellow : .yellow )
                    .padding(.trailing, -6)
                Text("Comment \(commentCount)")
                
                Spacer()
                
                
                // Share icon with label and count
                Image(systemName: "square.and.arrow.up") .foregroundColor(Color("babyBlue"))
                    .padding(.trailing, -6)
                Text("Share 0")
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            
            
            
            
            Divider()
                .background(Color.darkBlue)
            
            HStack {
                // Text field for the comment
                TextField("Add your comment", text:$commentText)
                    .padding(10)
                    .background(Color.gray.opacity(0.1)) // Light gray background
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                // Send button
                Button(action: {
                    // Handle send comment action
                    // TODO: Implement the action
                }) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20) // Adjust size of the icon
                        .padding(10)
                }
                .background(Color.blue) // Use a more appealing color
                .foregroundColor(.white) // White color for the icon
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 8)
            
            
            VStack(spacing: 8) {
                ForEach(post.comments) { comment in
                    CommentCardView(comment: comment)
                }
            }
            .padding(.vertical, 5)
            
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        
        .cornerRadius(8)
        .shadow(radius: 4)
       // .padding(5)
    }
    
    
}
struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.darkBlue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
#Preview {
    PostCardView(post: post1) // is this correct ?
        .previewLayout(.sizeThatFits)
}
