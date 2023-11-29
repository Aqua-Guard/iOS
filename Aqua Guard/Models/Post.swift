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

struct PostList{
    static let postList = [post1,post2,post3]
}
let post1 = Post(id: "p1", userName: "Youssef Farhat", userRole: "Partner", description: "Dive into the serene beauty of aquatic life with AquaGard! 🐠💧 Whether you're a seasoned aquarist or just starting your water gardening journey, our latest post offers a treasure trove of insights", userImage: "youssef", postImage: "post1", nbLike: 0, nbComments: 1, nbShare: 10, likes: [], comments: [comment1])

let post2 = Post(id: "p2", userName: "Malek labidi", userRole: "partner", description: "🐢 Dive into the enchanting world of aquatic turtles! Explore their unique lifestyle and habitat in our latest post.", userImage: "user", postImage: "tortue", nbLike: 2, nbComments: 2, nbShare: 15, likes: [like1, like2], comments: [comment1, comment2])

let post3 = Post(id: "p3", userName: "AlexSmith", userRole: "Traveler", description: "Exploring the world!", userImage: "yousseff", postImage: "cheval", nbLike: 1, nbComments: 1, nbShare: 20, likes: [like2], comments: [comment2])
