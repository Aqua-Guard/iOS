//
//  EditProfile.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 27/12/2023.
//

import SwiftUI
import PhotosUI


struct EditProfile: View {
        var screenWidth = UIScreen.main.bounds.width
        var screenHeight = UIScreen.main.bounds.height
        @State var isDarkModeEnabled: Bool = false
        @State var emailNotif: Bool = false
        @State private var deleteAlert = false
        let userImage = LoginViewModell.defaults.string(forKey: "image")
        @StateObject var viewModel: UserViewModel = UserViewModel()
        @State private var navigationActive: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage = UIImage()

    @State var selectedItem: PhotosPickerItem? = nil;
    @State var selectedImageData: Data?
    

    
    
        var body: some View {
            NavigationView {
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [isDarkModeEnabled ? Color.black : Color.white, isDarkModeEnabled ? Color.lightBlue : Color.lightBlue]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)

                        VStack{
                            VStack {
                                
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                                    .foregroundColor(.darkBlue)
                                    .clipShape(Circle())

                                Button(action: {
                                    self.isImagePickerPresented.toggle()
                                }) {
                                    Label("Select New Profile Picture", systemImage: "pencil")
                                        .foregroundColor(.darkBlue)
                                }
                                .sheet(isPresented: $isImagePickerPresented) {
                                    ImagePickerEvent(didImagePicked: { image in
                                        self.selectedImage = image
                                    }, isImagePickerPresented: $isImagePickerPresented)
                                }
                                
                                
                                VStack {
                                    TextInputField("", text: $viewModel.username, error: $viewModel.error)
                                        .padding(.bottom)
                                }
                                .onAppear {
                                    viewModel.username = LoginViewModell.defaults.string(forKey: "username") ?? ""
                                }
                                
                                VStack {
                                    TextInputField("", text: $viewModel.email, error: $viewModel.error)
                                        .padding(.bottom)
                                }
                                .onAppear {
                                    viewModel.email = LoginViewModell.defaults.string(forKey: "email") ?? ""
                                }
                                
                                VStack {
                                    TextInputField("", text: $viewModel.firstName, error: $viewModel.error)
                                        .padding(.bottom)
                                }
                                .onAppear {
                                    viewModel.firstName = LoginViewModell.defaults.string(forKey: "firstName") ?? ""
                                }
                                
                                VStack {
                                    TextInputField("", text: $viewModel.lastName, error: $viewModel.error)
                                        .padding(.bottom)
                                }
                                .onAppear {
                                    viewModel.lastName = LoginViewModell.defaults.string(forKey: "lastName") ?? ""
                                }
                                
                                
                                //Spacer()
                                
                                ZStack {
                                    NavigationLink(
                                        destination: AccountScreen(),
                                        isActive: $navigationActive
                                    ) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    
                                    Button(action: {
                                        Task {
                                            if selectedImage == nil {
                                                if let imagePath = Bundle.main.path(forResource: LoginViewModell.defaults.string(forKey: "image") ?? "", ofType: "png") {
                                                    selectedImage = UIImage(contentsOfFile: imagePath)!
                                                }
                                            }
                                            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                                                await viewModel.updateProfile(email: viewModel.email, firstName: viewModel.firstName, lastName: viewModel.lastName, image: imageData, username: viewModel.username)
                                                navigationActive = true
                                                /*LoginViewModell.defaults.set($viewModel.email, forKey: "email")
                                                LoginViewModell.defaults.set($viewModel.username, forKey: "username")
                                                LoginViewModell.defaults.set($viewModel.firstName, forKey: "firstName")
                                                LoginViewModell.defaults.set($viewModel.lastName, forKey: "lastName")
                                                print("imageData")*/
                                                /*print(imageData)
                                                LoginViewModell.defaults.set(URL(string: imageData.base64EncodedString())?.path(), forKey: "image")*/
                                                if self.viewModel.isLoading {
                                                    //$navigationActive = true
                                                    
                                                }
                                                

                                            }
                                            else{
                                                print("errrrrrrrror")
                                            }
                                        }
                                    }) {
                                        Text ("Update Profile")
                                            .foregroundColor (.white)
                                            .fontWeight (.semibold)
                                            .font(.system(size:22))
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .frame(width: screenWidth * 0.88, height: screenWidth * 0.13)
                                    }
                                }
                                
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.roundedRectangle)
                                .tint(Color.blue)
                                .cornerRadius(30)
                                .padding(.horizontal)
                            }
                            
                        }
                }
            }.navigationBarBackButtonHidden(true)
            .navigationBarColor(.darkBlue, textColor: UIColor.white)
        
            
            
            
    }
}

#Preview {
    EditProfile()
}
