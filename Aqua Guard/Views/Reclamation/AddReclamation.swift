//
//  AddReclamation.swift
//  Aqua Guard
//
//  Created by adem on 13/12/2023.
//

import SwiftUI

struct AddReclamation: View {
    @ObservedObject var viewModel = ReclamationViewModel()
    @State private var navigateToReclamationList = false
    @State private var title = ""
    @State private var description = ""
    @State private var selectedUIImage: UIImage?
    @State private var isImagePickerDisplayed = false

    var body: some View {
        VStack {
            Text("Add Reclamation")
                .foregroundColor(.black)
                .bold()
            

            ZStack {
               
                    if let selectedUIImage = selectedUIImage {
                        Image(uiImage: selectedUIImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        ZStack {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 50)
                                .foregroundColor(.red)
                                .onTapGesture {

                                }
                        }
                    } else {
                        Image("imagepicker")
                            .resizable()
                            .scaledToFit()
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
                    .frame(width: 330)
                    .background(Color.darkBlue)
                    .clipShape(Capsule())
            }
            .sheet(isPresented: $isImagePickerDisplayed) {
                // Present the image picker
                ImagePickerReclamation(selectedUIImage: $selectedUIImage)
            }

            // Title Input
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color("background_splash_screen"))

            // Description Input
            TextEditor(text: $description)
                .frame(maxHeight: 150)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.7)
                )
                .padding()
                .overlay(
                    Group {
                        if description.isEmpty {
                            Text("Enter your description...")
                                .foregroundColor(Color.gray.opacity(0.5))
                                .padding()
                                .padding()
                        }
                    }, alignment: .topLeading
                )
            Button(action: {
                Task {
                    if let selectedUIImage = selectedUIImage {
                               if let imageData = selectedUIImage.jpegData(compressionQuality: 0.8) {
                                   await viewModel.AddReclamation(title: title, description: description, image: imageData)
                                   navigateToReclamationList = true

                               } else {
                                   // Handle the error - could not convert image to Data
                               }
                           }
                   
                }
            }) {
                Text("Save")
                    .frame(width: 300)
                    .foregroundColor(.white)
                    .padding()

                    .background(Color.red)
                    .clipShape(Capsule())
            }  .fullScreenCover(isPresented: $navigateToReclamationList, content: {
                ReclamationListView()
            })
            Spacer()
        }
        .padding()
        .background(Color("background_splash_screen"))
        .navigationBarItems(leading:
            HStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 70, height: 10)
                .padding(.leading,148)
            

                Spacer()
                
            }


        )
    }
}

struct ImagePickerReclamation: UIViewControllerRepresentable {
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
        var parent: ImagePickerReclamation

        init(_ parent: ImagePickerReclamation) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedUIImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


    struct AddReclamation_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                AddReclamation().environmentObject(ReclamationViewModel())
            }
        }
    }
