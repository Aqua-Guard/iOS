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
                Image(comment.commentAvatar) // Replace with your actual image name
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.darkBlue, lineWidth: 3)) // Blue border for the profile picture
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(comment.commentUsername)
                        .font(.headline) // Slightly larger font for the name
                        .fontWeight(.bold)
                    
                    Text(comment.comment)
                        .font(.subheadline) // Smaller font for the comment body
                        .foregroundColor(Color.gray) // A softer color for the comment text
                        .lineLimit(3) // Limit the number of lines to prevent very long comments from taking up too much space
                        .multilineTextAlignment(.leading)
                }
                .padding(.leading, 8) // Reduced padding to bring the text closer to the image
                
                Spacer()
                
                HStack(spacing: 16) { // Increase spacing for better touch targets
                    Button(action: {
                        // Handle edit action
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(Color.blue) // Use the same blue as the image border for consistency
                    }
                    
                    Button(action: {
                        // Handle delete action
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(Color.red)
                    }
                }
            }
            .padding() // Padding inside the HStack for spacing around the content
        }
        .background(Color.white) // White background for the card
        .cornerRadius(10) // Rounded corners for the card
        .shadow(radius: 2) // Subtle shadow for a lift effect
        //.padding(.horizontal)
    }
}

#Preview {
    CommentCardView(comment: comment1)
        .previewLayout(.sizeThatFits)
    .padding()
}
