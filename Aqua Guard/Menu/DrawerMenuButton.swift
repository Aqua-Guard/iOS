//
//  DrawerMenuButton.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 28/11/2023.
//

import SwiftUI

struct DrawerMenuButton: View {
    var name : String
    var image:String
    @Binding var selectedMenu:String
    
    var animation: Namespace.ID
    var body: some View {
        Button(action:{
            withAnimation(.spring()){
                selectedMenu = name
            }
        },label: {
            HStack(spacing: 10){
                Image(systemName: image)
                    .font(.title2)
                    .foregroundColor(selectedMenu == name ? .white:.darkBlue)
                Text(name)
                    .foregroundColor(selectedMenu==name ? .white: .darkBlue)
            }
            .padding(.horizontal)
            .padding(.vertical,12)
            .frame(width: 200,alignment: .leading)
            // smooth Slide Animation...
            .background(
                ZStack{
                    if selectedMenu == name{
                        Color.darkBlue
                            .cornerRadius(10)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                    else{
                        Color.clear
                    }
                }
            )
    
        })
    }
}

#Preview {
    Home()
}

