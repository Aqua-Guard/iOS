//
//  FontPickerView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 13/12/2023.
//

import SwiftUI
struct FontPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var fontName: String
    let fonts = UIFont.familyNames.sorted()

    var body: some View {
        List(fonts, id: \.self) { font in
            Button(action: {
                self.fontName = font
                self.presentationMode.wrappedValue.dismiss() // Dismiss the sheet
            }) {
                Text(font)
                    .font(Font.custom(font, size: 16))
            }
        }
    }
}
