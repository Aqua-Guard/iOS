//
//  RegisterView.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/29/23.
//

import SwiftUI
import PhotosUI


struct ImagePickerUser: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerUser
        var didImagePicked: (UIImage) -> Void

        init(parent: ImagePickerUser, didImagePicked: @escaping (UIImage) -> Void) {
            self.parent = parent
            self.didImagePicked = didImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                didImagePicked(uiImage)
            }

            parent.isImagePickerPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
    }

    var didImagePicked: (UIImage) -> Void
    @Binding var isImagePickerPresented: Bool

    init(didImagePicked: @escaping (UIImage) -> Void, isImagePickerPresented: Binding<Bool>) {
        self.didImagePicked = didImagePicked
        self._isImagePickerPresented = isImagePickerPresented
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, didImagePicked: didImagePicked)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct RegisterView: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State var email: String = ""
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var errorValue: String = ""
    @State private var isActive = false
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedImage = UIImage()
    @State private var showSheet = false
    @State private var isImagePickerPresented: Bool = false

    @State var selectedItem: PhotosPickerItem? = nil;
    @State var selectedImageData: Data?

    var body: some View {
        NavigationView {
            
            ZStack{
                Image("login_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: screenWidth * 1, height: screenWidth * 1)
                ScrollView {
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: screenWidth * 0.6, height: screenWidth * 0.6)
                    VStack {
                        
                        
                        TextInputField("Email", text: $email, error: $viewModel.emailError)
                        
                        TextInputField("Username", text: $username, error: $viewModel.usernameError)
                        
                        
                        Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
                            .scaledToFit()
                            .clipShape(Circle())

                        Button(action: {
                            self.isImagePickerPresented.toggle()
                            
                        }) {
                            Label("Select Profile Picture", systemImage: "person.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePickerUser(didImagePicked: { image in
                                self.selectedImage = image
                            }, isImagePickerPresented: $isImagePickerPresented)
                        }
                        
                        TextInputField("First name", text: $firstName, error: $viewModel.firstNameError)
                        
                        TextInputField("Last name", text: $lastName, error: $viewModel.lastNameError)
                        
                        PasswordInputField("Password", text: $password, error: $viewModel.passwordError)
                        
                        PasswordInputField("Confirm password", text: $viewModel.confirmPassword, error: $viewModel.confirmPasswordError)
                        //Spacer()
                        Button(action: {
                            //self.viewModel.validate()
                            Task {
                                await viewModel.signup()
                                if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                                    try await viewModel.register(email: email, firstName: firstName, lastName: lastName, image: imageData, username: username, password: password)
                                }
                                else{
                                    print("errrrrrrrror")
                                }
                            }
                        }, label: {
                                Text("Sign in")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                                    .frame(width: screenWidth * 0.91, height: screenWidth * 0.13)
                        })
                        
                            .navigationBarHidden(true) // Hide the navigation bar
                            .background(
                                NavigationLink(destination: LoginView(), isActive: $viewModel.isLoading) {
                                    EmptyView()
                                }
                            )
                        .background(Color.lightBlue)
                        .cornerRadius(30)
                        .padding(.top)
                    }
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 20))
                            .foregroundColor(Color.black)
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Sign in")
                                .font(.system(size: 20))
                                .foregroundColor(Color.lightBlue)
                        }
                        
                    }
                    .padding(.bottom)
                }
            }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterView()
}
    
