//
//  UpdatePostView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 7/12/2023.
//

import SwiftUI

struct UpdatePostView: View {
    let post: PostModel
    @StateObject var viewModel = PostViewModel()
    @State private var selectedUIImage: UIImage?
    @State private var isImagePickerDisplayed = false
    @State private var postDescription = ""
    
    @State private var showToast = false
    @State private var navigateBack = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(post: PostModel) {
        self.post = post
        // Initialize the likeCount state with the initial like count of the post
        _postDescription = State(initialValue: post.description)
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                
                VStack {
                    Spacer()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            
                            ZStack {
                                if let selectedUIImage = selectedUIImage {
                                    Image(uiImage: selectedUIImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
                                } else {
                                    AsyncImage(url: URL(string: "http://127.0.0.1:9090/images/post/\(post.postImage)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView() // This will show a loader until the image is loaded
                                    }
                                    .frame(width: 300, height: 300)
                                }
                            }
                            
                            
                            // Button to choose an image
                            Button(action: {
                                isImagePickerDisplayed = true
                            }) {
                                Text("Choose Image")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.darkBlue)
                                    .clipShape(Capsule())
                            }
                            //.padding()
                            
                            
                            // Description Label
                            descriptionTxtVw
                            
                            
                            // Text editor for the post description
                            textEditorVw
                            
                            HStack{
                                Button(action: {
                                    Task {
                                                await viewModel.updatePost(postId: post.idPost, description: postDescription)
                                            
                                        }
                                    
                                }) {
                                    Text("Submit Post")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.darkBlue)
                                        .clipShape(Capsule())
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            // Submit button
                            
                            
                            
                            Spacer()
                            
                            
                            
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding([.leading, .trailing], 10)
                    }
                    .sheet(isPresented: $isImagePickerDisplayed) {
                        // Present the image picker
                       /* ImagePicker(selectedUIImage: $selectedUIImage)*/
                        
                    }
                    .navigationBarTitle("Update Post", displayMode: .inline)
                    .background(Image("background_splash_screen")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all))
                }
            }
            .alert(isPresented: $viewModel.updatePostAlert) {
                Alert(title: Text("Post Update"), message: Text(viewModel.alertMessageUpdatePost), dismissButton: .default(Text("OK")))
            }}
        .onChange(of: viewModel.updatedwithSucsess) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
    private var textEditorVw: some View {
        TextEditor(text: $postDescription)
            .frame(height: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
    
    // Description text view
    private var descriptionTxtVw: some View {
        Text("Description")
            .font(.headline)
            .foregroundColor(.gray)
    }
}


#Preview {
    UpdatePostView(post: post1)
}
