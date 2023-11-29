//
//  PasswordInputField.swift
//  Aqua Guard
//
//  Created by Amira Ben Mbarek on 11/29/23.
//

import SwiftUI

struct PasswordInputField: View {

    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
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
                ZStack(alignment: .trailing) {
                    Group {
                        if isSecured {
                            SecureField("", text: $text)
                                .textContentType(.password)
                        } else {
                            TextField("", text: $text)
                                .autocapitalization(.none)
                                .textContentType(.password)
                        }
                    }.padding(.vertical, 15)
                    
                    Button(action: {
                        isSecured.toggle()
                    }) {
                        Image(systemName: self.isSecured ? "eye.slash" : "eye")
                            .accentColor(.gray)
                    }
                    .buttonStyle(.borderless)
                }
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
