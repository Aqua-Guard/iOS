//
//  CommentCardView.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import SwiftUI

struct CommentCardView: View {
    let comment:Comment
    var body: some View {
        VStack(spacing: 2) {
            Divider()
                .background(Color.gray.opacity(0.5))
            
            HStack {
                
                if let avatarName = comment.commentAvatar, let url = URL(string: "https://aquaguard-tux1.onrender.com/images/user/" + avatarName) {
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
                VStack(alignment: .leading, spacing: 4) {
                    Text(comment.commentUsername!)
                        .font(.headline) // Slightly larger font for the name
                        .fontWeight(.bold)
                    
                    Text(comment.comment!)
                        .font(.subheadline) // Smaller font for the comment body
                        .foregroundColor(Color.gray) // A softer color for the comment text
                        .lineLimit(3) // Limit the number of lines to prevent very long comments from taking up too much space
                        .multilineTextAlignment(.leading)
                }
                .padding(.leading, 2) // Reduced padding to bring the text closer to the image
                
                Spacer()
                
//                HStack(spacing: 1) { // Increase spacing for better touch targets
//                    Button(action: {
//                        // Handle edit action
//                    }) {
//                        Image(systemName: "pencil")
//                            .foregroundColor(Color.blue) // Use the same blue as the image border for consistency
//                    }
//                    
//                    Button(action: {
//                        // Handle delete action
//                    }) {
//                        Image(systemName: "trash")
//                            .foregroundColor(Color.red)
//                    }
//                }
            }
            .padding() // Padding inside the HStack for spacing around the content
        }
        
        //.padding(.horizontal)
    }
}

#Preview {
    CommentCardView(comment: comment1)
        .previewLayout(.sizeThatFits)
    .padding()
}
