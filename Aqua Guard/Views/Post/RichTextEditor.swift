//
//  RichTextEditor.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 13/12/2023.
//

import SwiftUI

struct RichTextEditor: UIViewRepresentable {
    @Binding var text: String
    var isBold: Bool
    var isItalic: Bool
    var fontName: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        var traits: UIFontDescriptor.SymbolicTraits = []
        if isBold {
            traits.insert(.traitBold)
        }
        if isItalic {
            traits.insert(.traitItalic)
        }
        uiView.font = UIFont(descriptor: UIFontDescriptor(name: fontName, size: 14).withSymbolicTraits(traits) ?? UIFontDescriptor(), size: 14)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
