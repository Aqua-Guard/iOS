//
//  AddPostView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 7/12/2023.
//
import SwiftUI

struct AddPostView: View {
    @ObservedObject var viewModel = PostViewModel()
    @State private var selectedUIImage: UIImage?
    @State private var isImagePickerDisplayed = false
    @State private var postDescription = ""
    
    @State private var showToast = false
    @State private var navigateBack = false

    @Environment(\.presentationMode) var presentationMode
    
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
                                                      .foregroundColor(.blue) // Adjust this color if you have a custom color set
                                              } else {
                                                  Image(systemName: "photo")
                                                      .resizable()
                                                      .scaledToFit()
                                                      .frame(width: 300, height: 300)
                                                      .foregroundColor(.darkBlue) // Adjust this color if you have a custom color set
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
                                        if let selectedUIImage = selectedUIImage {
                                                   if let imageData = selectedUIImage.jpegData(compressionQuality: 0.8) {
                                                       await viewModel.createPost(description: postDescription, image: imageData)
                                                       
                                                   } else {
                                                       // Handle the error - could not convert image to Data
                                                   }
                                               }
                                       
                                    }
                                }) {
                                    Text("Submit Post")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.darkBlue)
                                        .clipShape(Capsule())
                                    // i want to make this bottom on the left
                                    
                                }
                                
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
                        ImagePicker(selectedUIImage: $selectedUIImage)
                        
                    }
                    .navigationBarTitle("Add Post", displayMode: .inline)
                    .background(Image("background_splash_screen")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all))
                }
            }
            .alert(isPresented: $viewModel.createdPostAlert) {
                Alert(title: Text("Post Creation"), message: Text(viewModel.alertMessageCreationPost), dismissButton: .default(Text("OK")))
            }}
        .onChange(of: viewModel.createdwithSucsess) { success in
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

// ImagePicker to handle image selection
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedUIImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedUIImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Preview
#Preview {
  

   // let previewViewModel = PostViewModel()

           // Now provide the view model to the AddPostView
           AddPostView().environmentObject(PostViewModel())
       
}

