//
//  RegisterView.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/29/23.
//

import SwiftUI
import PhotosUI

struct RegisterView: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State var textValue: String = ""
    @State var errorValue: String = ""
    @State private var isActive = false
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    
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
                        
                        
                        TextInputField("Email", text: $viewModel.email, error: $viewModel.emailError)
                        
                        TextInputField("Username", text: $viewModel.username, error: $viewModel.usernameError)
                        
                        
                        HStack{
                            
                            Text("Select Profile Picture")
                                .foregroundColor(.blue)
                                .font(.system(size: 20))

                            
                            PhotosPicker(selection:$selectedItem, matching: .images, photoLibrary: .shared()){
                                if let selectedImageData, let image = UIImage(data: selectedImageData){
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
                                        .scaledToFit()
                                        .clipShape(Circle())
                                    
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)

                                        .scaledToFit()
                                        .clipShape(Circle())
                                }
                            }
                            
                            .onChange(of: selectedItem) { newValue in
                                Task{
                                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                        
                                    }
                                    self.viewModel.image = selectedImageData
                                }
                            }
                        }
                        
                        TextInputField("First name", text: $viewModel.firstName, error: $viewModel.firstNameError)
                        
                        TextInputField("Last name", text: $viewModel.lastName, error: $viewModel.lastNameError)
                        
                        PasswordInputField("Password", text: $viewModel.password, error: $viewModel.passwordError)
                        
                        PasswordInputField("Confirm password", text: $viewModel.confirmPassword, error: $viewModel.confirmPasswordError)
                        //Spacer()
                        Button(action: {
                            self.viewModel.validate()
                            Task {
                                await viewModel.signup()
                                NavigationLink(destination: LoginView(), isActive: $viewModel.isLoading) {
                                }
                            }
                        }, label: {
                            /*NavigationLink(destination: LoginView(), isActive: $viewModel.isLoading) {*/
                                Text("Sign in")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                                    .frame(width: screenWidth * 0.91, height: screenWidth * 0.13)
                            //}
                        })
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
