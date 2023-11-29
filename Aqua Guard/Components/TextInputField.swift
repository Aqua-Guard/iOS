//
//  TextInputField.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/29/23.
//

import SwiftUI

struct TextInputField: View {
    var title: String
    @Binding var text: String
    @Binding var error: String
    
    init(_ title: String, text:Binding<String>, error:Binding<String>) {
        self.title = title
        self._text = text
        self._error = error
    }
    var body: some View {
        VStack {
            ZStack (alignment: .leading) {
                Text(title)
                    .foregroundColor(text.isEmpty ? Color (.placeholderText) : .black)
                    .offset (y: text.isEmpty ? 0 :-25)
                    .scaleEffect(text.isEmpty ? 1: 0.8, anchor: .leading)
                    .animation(.default, value: text)
                TextField("", text: $text)
                    .autocapitalization(.none)
                    .padding (.vertical, 15)
                    .keyboardType(title == "Email" ? .emailAddress : .default)
            }
            .padding(.horizontal)
            .padding(.top, text.isEmpty ? 0 : 15)
            .animation(.easeIn, value: text)
            .overlay(
                RoundedRectangle(cornerRadius: 35)
                    .stroke(error == "" ? Color.black : Color.red)
            )
            .padding(.horizontal)
            Text(error)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
        }
    }
}

