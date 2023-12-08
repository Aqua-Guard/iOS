//
//  ImagePicker.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 7/12/2023.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        var didImagePicked: (UIImage) -> Void

        init(parent: ImagePicker, didImagePicked: @escaping (UIImage) -> Void) {
            self.parent = parent
            self.didImagePicked = didImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                didImagePicked(uiImage)
            }

            parent.presentationMode.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.dismiss()
        }
    }

    var didImagePicked: (UIImage) -> Void
    @Binding var presentationMode: PresentationMode

    init(didImagePicked: @escaping (UIImage) -> Void, presentationMode: Binding<PresentationMode>) {
        self.didImagePicked = didImagePicked
        self._presentationMode = presentationMode
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





