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
                if let avatarName = like.likeAvatar, let url = URL(string: "http://127.0.0.1:9090/images/user/" + avatarName) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.darkBlue, lineWidth: 3))
                        case .failure(_):
                            Image(systemName: "person.circle.fill") // Placeholder for failure
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.darkBlue, lineWidth: 3))
                        case .empty:
                            ProgressView() // Loading indicator
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "person.circle") // Placeholder for nil
                }
                Text(like.likeUsername!)
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
