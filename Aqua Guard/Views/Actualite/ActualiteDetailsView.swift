//
//  ActualiteDetailsView.swift
//  Aqua Guard
//
//  Created by adem on 1/12/2023.
//

import SwiftUI

struct ActualiteDetailsView: View {
    @State private var selectedOption: Int? = nil
        let options = ["true", "not true", "maybe"]
    var body: some View {
           VStack {
               Image("photo") // Replace with your actual image name
                   .resizable()
                   .scaledToFit()
                   .frame(width: 850, height: 262)
               

               Text("Title")
                      .font(.title)
                      .fontWeight(.medium)
                      .padding(.leading)
                      .frame(maxWidth: .infinity, alignment: .leading)
               Text("Description ; statement that tells you how something or someone looks, sounds, etc. : words that describe something or someone. [count] Reporters called the scene “a disaster area,”")
                   .font(.system(size: 12))
                      .fontWeight(.medium)
                      .padding(.leading)
                      .padding(.top, 1)
                      .frame(maxWidth: .infinity, alignment: .leading)
               Text("Text ;Art Deco architecture in New York City flourished during the 1920s and 1930s, and is found in governmental, residential, and commercial buildings, from towering skyscrapers to modest middle-class housing and municipal buildings, across all five boroughs. The style broke with traditional architectural conventions and was characterized by verticality, ornamentation, and new building materials. It was influenced by worldwide decorative arts trends, the rise of Art Deco architecture in New York City flourished during the 1920s and 1930s, and is found in governmental, residential, and commercial buildings, from towering skyscrapers to modest middle-class housing and municipal buildings, across all five boroughs. The style broke with traditional architectural conventions and was characterized by verticality, ornamentation, and new building materials. It was influenced by worldwide decorative arts trends, the rise of ")
                   .font(.system(size: 12))
                   .fontWeight(.light)
                      .padding(.leading)
                      .padding(.top, 30)
                      .frame(maxWidth: .infinity, alignment: .leading)
               Picker("Select an Option", selection: $selectedOption) {
                               ForEach(0..<options.count) { index in
                                   Text(self.options[index])
                               }
                           }
                           .pickerStyle(SegmentedPickerStyle())
                           .padding(.horizontal, 20) // Apply padding to the picker
               Spacer()
           }.navigationBarTitle("Actualite Title", displayMode: .inline)

    }
}

#Preview {
    ActualiteDetailsView()
}
