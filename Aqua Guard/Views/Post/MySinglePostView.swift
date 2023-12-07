//
//  MySinglePostView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 6/12/2023.
//

import SwiftUI

import SimpleToast

struct MySinglePostView: View {
    @ObservedObject var viewModel = PostViewModel()
    
    let post: PostModel

    
    
    @State var showingLikeBottomSeet = false
    @State var showingCommentBottomSeet = false
    
    @State private var showingDeleteAlert = false
    @State private var postToDeleteId: String?
    
  
    
    
    
    var body: some View {
        
        
        // MaterialCardView equivalent in SwiftUI is a VStack inside a RoundedRectangle
        VStack(alignment: .leading) {
            // User info and post image
            HStack {
                
                AsyncImage(url: URL(string: "http://127.0.0.1:9090/images/user/\(post.userImage ?? "")")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable() // Make the image resizable
                            .aspectRatio(contentMode: .fill) // Fill the frame while maintaining aspect ratio
                    case .failure(_):
                        Image(systemName: "photo") // A fallback image in case of failure
                            .foregroundColor(.gray)
                    case .empty:
                        ProgressView() // An activity indicator while the image is loading
                    @unknown default:
                        EmptyView() // A default view for unknown phase
                    }
                }
                .frame(width: 65, height: 65) // Set the frame size for the image
                .clipShape(Circle()) // Clip the image to a circle
                .overlay(Circle().stroke(Color.darkBlue, lineWidth: 2)) // Add a border around the image
                
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
                // Task {
                //await viewModel.deletePost(postId: post.idPost)
                //}
                
                Spacer()
    
                
                NavigationLink(destination: UpdatePostView(post: post)) {
                    Image(systemName: "pencil")
                        .foregroundColor(.darkBlue) // Make sure .darkBlue is defined in your Color extension
                }
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.postToDeleteId = self.post.idPost
                            self.showingDeleteAlert = true
                        }
              
                
                
                
            }
            
            Divider()
                .background(Color.darkBlue)
            
            // Post description
            Text(post.description)
                .padding(16)
                .foregroundColor(.secondary)
            
            //  i want ti center this image
            AsyncImage(url: URL(string: "http://127.0.0.1:9090/images/post/\(post.postImage)")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Fit the content in the current view size
                        .frame(height: 200) // Set the frame height
                        .frame(maxWidth: .infinity, alignment: .center) // Set the frame width to be as wide as possible and align it to the center
                case .failure(_):
                    Image(systemName: "photo") // An image to display in case of failure to load
                        .foregroundColor(.gray)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                case .empty:
                    ProgressView() // An activity indicator until the image loads
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                @unknown default:
                    EmptyView() // Default view in case of unknown phase
                }
            }
            .padding(.bottom)
            
            
            
            Divider()
                .background(Color.darkBlue)
            
            
            HStack {
                // Like icon with label and count
                
                Button(action: {
                    showingLikeBottomSeet.toggle()
                })
                {
                    Image(systemName: post.nbLike > 0 ? "heart.fill" : "heart")
                        .foregroundColor(.pink)
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
                    Image(systemName: post.nbComments > 0 ? "text.bubble.fill" : "text.bubble")
                        .foregroundColor(post.nbComments > 0 ? .yellow : .yellow )
                        .padding(.trailing, -6)
                    Text("Comment \(post.nbComments)")
                        .foregroundStyle(Color.black)
                } .sheet(isPresented: $showingCommentBottomSeet){
                    CommentBottomSheetView(comments: post.comments, viewModel: viewModel , postId: post.idPost)
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
        .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Confirm Delete"),
                        message: Text("Are you sure you want to delete this post?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let postId = postToDeleteId {
                                Task {
                                    await viewModel.deletePost(postId: postId)
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
    }
    
    
}




#Preview {
    
    // Create a sample PostModel
    let samplePost = PostModel(
        idPost: "sampleID",
        userName: "Sample User",
        userRole: "User Role",
        description: "Sample Description",
        userImage: "sampleImage",
        postImage: "sampleImage",
        nbLike: 10,
        nbComments: 5,
        nbShare: 3,
        likes: [],
        comments: []
    )
    
    // Create an instance of PostViewModel
    let viewModel = PostViewModel()
    viewModel.posts = [samplePost]
    
    // Pass the viewModel and the index of the post to preview
    return MySinglePostView(viewModel: viewModel, post: post1)
    
}
