//
//  Like.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import Foundation

struct Like {
    let id = UUID()
    let likeAvatar: String
    let likeUsername: String
}

let like1 = Like(likeAvatar: "avatar1.png", likeUsername: "user1")
let like2 = Like(likeAvatar: "avatar2.png", likeUsername: "user2")
