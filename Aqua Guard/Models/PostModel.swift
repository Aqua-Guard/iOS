//
//  Post.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import Foundation
struct PostModel : Decodable { 
    let idPost: String
    let userName: String
    let userRole: String
    let description: String
    let userImage: String
    let postImage: String
    var nbLike: Int
    var nbComments: Int
    let nbShare: Int
    var likes: [Like]
    var comments: [Comment]
}
 let post1 = PostModel(idPost: "p1", userName: "Youssef Farhat", userRole: "Partner", description: "Dive into the serene beauty of aquatic life with AquaGard! 🐠💧 Whether you're a seasoned aquarist or just starting your water gardening journey, our latest post offers a treasure trove of insights", userImage: "youssef", postImage: "post1", nbLike: 2, nbComments: 1, nbShare: 10,likes: [like1,like2] ,comments: [comment1,comment2,comment1])
