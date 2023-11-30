//
//  LikeCardView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 30/11/2023.
//

import SwiftUI

struct LikeCardView: View {
    let like:Like
    var body: some View {
        VStack(spacing: 2) {
            Divider()
                .background(Color.gray.opacity(0.5))
            
            HStack {
                Image(like.likeAvatar) // Assuming you have the images in your assets
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("darkBlue"), lineWidth: 3)) // Use the color set in your assets
                
                Text(like.likeUsername)
                    .font(.system(size: 16, weight: .bold)) // 16sp translates roughly to 16pt in SwiftUI
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                
                Spacer()
                
                // Liked Text and Icon
                HStack {
                    Text("Liked")
                        .foregroundColor(Color.pink)
                    
                    Image(systemName: "heart.fill") // Replace with your like icon
                        .foregroundColor(Color.pink)                 }
            }
            .padding(8)
        }
        .padding(2)
    }
}


#Preview {
    LikeCardView(like: like1)
        .previewLayout(.sizeThatFits)
        .padding()
}
