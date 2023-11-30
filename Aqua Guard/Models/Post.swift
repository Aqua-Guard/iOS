//
//  Post.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import Foundation
struct Post : Identifiable {
    let id: String
    let userName: String
    let userRole: String
    let description: String
    let userImage: String
    let postImage: String
    var nbLike: Int
    let nbComments: Int
    let nbShare: Int
    let likes: [Like]
    let comments: [Comment]
}
 let post1 = Post(id: "p1", userName: "Youssef Farhat", userRole: "Partner", description: "Dive into the serene beauty of aquatic life with AquaGard! 🐠💧 Whether you're a seasoned aquarist or just starting your water gardening journey, our latest post offers a treasure trove of insights", userImage: "youssef", postImage: "post1", nbLike: 0, nbComments: 1, nbShare: 10, likes: [], comments: [comment1])
