//
//  AddPostView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 7/12/2023.
//
import SwiftUI
import InstantSearchVoiceOverlay


struct AddPostView: View {
    @ObservedObject var viewModel = PostViewModel()
    @State private var selectedUIImage: UIImage?
    @State private var isImagePickerDisplayed = false
    @State private var postDescription = ""
    
    @State private var showToast = false
    @State private var navigateBack = false
    
    @State private var isChatSheetPresented = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let voiceOverlayController = VoiceOverlayController()
    
    var body: some View {
        NavigationView {
            ZStack {
                
                
                VStack {
                    Spacer()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Please fill in the following details to create a post:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                            VStack{
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
                                            .frame(width: 300, height: 200)
                                            .foregroundColor(.darkBlue) // Adjust this color if you have a custom color set
                                    }
                                }
                                HStack{
                                    Spacer()
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
                                    Spacer()
                                }
                            }
                            
                            
                            // Description Label
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            // Text editor for the post description
                            TextEditor(text: $postDescription)
                                .frame(height: 150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            HStack {
                                Text("")
                                Spacer()
                                VStack {
                                    Spacer()
                                    Button(action: {
                                        voiceButtonTapped()
                                    }) {
                                        HStack {
                                            Image(systemName: "mic")
                                            Text("Voice Recorder")
                                        }
                                        
                                    }
                                    Spacer()
                                }
                                // Add this Spacer to push the VStack to the left
                                
                            }
                            
                            
                            
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
                                        .background(Color.blue)
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
                        ImagePickerPost(selectedUIImage: $selectedUIImage)
                        
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
            }
        
        }
        .onChange(of: viewModel.createdwithSucsess) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
    
    
   
    
    func voiceButtonTapped() {
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            voiceOverlayController.start(on: rootViewController, textHandler: { (text, final, _) in
                if final {
                    // Handle the final voice recording result
                    postDescription += text // text is a non-optional String
                }
            }, errorHandler: { (error) in
                print("Voice recording error: \(error?.localizedDescription ?? "")")
            })
        }
    }
    
    
    
  
}

// ImagePicker to handle image selection
struct ImagePickerPost: UIViewControllerRepresentable {
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
        var parent: ImagePickerPost
        
        init(_ parent: ImagePickerPost) {
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
