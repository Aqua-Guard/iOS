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
    
    @State private var text = "Type something..."
    @State private var isBold = false
    @State private var isItalic = false
    @State private var fontName = "Helvetica"
    
    @State private var showingFontPicker = false
   
    @State private var isLoading = false

    let voiceOverlayController = VoiceOverlayController()
    
    @State private var previousErrorMessage: String? = nil
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
                            // Image Selection
                            HStack{
                                Spacer()
                                Button(action: {
                                    isImagePickerDisplayed = true
                                }) {
                                    VStack {
                                        
                                        if let selectedUIImage = selectedUIImage {
                                            Image(uiImage: selectedUIImage )
                                                .resizable()
                                                .scaledToFit()
                                        } else {
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.blue)
                                                .padding()
                                        }
                                    }
                                    .frame(height: 200)
                                    .background(selectedUIImage == nil ? Color.gray.opacity(0.2) : Color.clear)
                                    .cornerRadius(12)
                                }
                                .sheet(isPresented: $isImagePickerDisplayed) {
                                    ImagePickerPost(selectedUIImage: $selectedUIImage)
                                }
                                Spacer()
                                
                            }
                            .padding()
                            HStack{
                                Text("Description :")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Button(action: {
                                    isBold.toggle()
                                }) {
                                    Label {
                                        Text("Bold")
                                    } icon: {
                                        Image(systemName: "bold")
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                Button(action: {
                                    isItalic.toggle()
                                }) {
                                    Label {
                                        Text("Italic")
                                    } icon: {
                                        Image(systemName: "italic")
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                Button(action: {
                                    showingFontPicker = true
                                }) {
                                    Label {
                                        Text("Font")
                                    } icon: {
                                        Image(systemName: "f.circle")
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            // Description Label
                            
                            VStack {
                                RichTextEditor(text: $postDescription, isBold: isBold, isItalic: isItalic, fontName: fontName)
                                    .frame(height: 150)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                
                                
                            }
                            .sheet(isPresented: $showingFontPicker) {
                                FontPickerView(fontName: $fontName)
                            }
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                } else {
                                    Button(action: {
                                        isLoading = true // Start loading
                                        Task {
                                            await viewModel.fetchAIDescription(prompt: postDescription)
                                            DispatchQueue.main.async {
                                                postDescription = viewModel.aiDescription
                                                isLoading = false // Stop loading once finished
                                            }
                                        }
                                    }) {
                                        Image("ChatGPT-Logo") // Replace with your actual image name
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                        Text("Use Chatgpt")
                                            .foregroundColor(.black)
                                            .padding(.leading, -15)
                                    }
                                }

                                Spacer()
                                VStack {
                                    Spacer()
                                    
                                    
                                    
                                    
                                    
                                    Button(action: {
                                        voiceButtonTapped()
                                    }) {
                                        HStack {
                                            Image(systemName: "mic")
                                                .foregroundColor(.black)
                                            Text("Voice Recorder").foregroundColor(.black)
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
                                                scheduleNotification(title: "New Post", contentt: "Check out the latest post by", username:viewModel.CurrentUserName ,userImage: viewModel.CurrentUserImage)
                                            } else {
                                                // Handle the error - could not convert image to Data
                                            }
                                        }
                                        
                                    }
                                    
                                }) {
                                    
                                    Text("Submit Post")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
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
    
    func downloadImage(from url: URL, completion: @escaping (URL?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let tempDirURL = FileManager.default.temporaryDirectory
            let localURL = tempDirURL.appendingPathComponent(url.lastPathComponent)
            do {
                try data.write(to: localURL)
                completion(localURL)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func scheduleNotification( title : String, contentt: String ,  username: String, userImage: String) {
        guard let imageUrl = URL(string: "https://aquaguard-tux1.onrender.com/images/user/\(userImage)") else { return }
        
        downloadImage(from: imageUrl) { localURL in
            guard let localURL = localURL else { return }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = "\(contentt) \(username)"
            
            
            if let attachment = try? UNNotificationAttachment(identifier: "image", url: localURL, options: nil) {
                content.attachments = [attachment]
            }
            
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
    
    func voiceButtonTapped() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("Could not retrieve the root view controller.")
            return
        }
        
        voiceOverlayController.start(on: rootViewController, textHandler: { (text, final, _) in
            if final {
                // Handle the final voice recording result
                DispatchQueue.main.async {
                    self.postDescription += text // Append the recognized text
                }
            }
        }, errorHandler: { (error) in
            // Use DispatchQueue.main.async to update any UI components or state
            DispatchQueue.main.async {
                if let errorDescription = error?.localizedDescription {
                    // Avoid printing the same error message multiple times
                    if self.previousErrorMessage != errorDescription {
                        print("Voice recording error: \(errorDescription)")
                        self.previousErrorMessage = errorDescription
                    }
                } else {
                    print("An unknown error occurred in voice recording.")
                }
            }
        })
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
