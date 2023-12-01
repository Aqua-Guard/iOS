//
//  Comment.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import Foundation
struct Comment : Identifiable{
    let id: String
    let idUser: String
    let idPost: String
    let commentAvatar: String
    let commentUsername: String
    let comment: String
}

let comment1 = Comment(id: "c1", idUser: "u1", idPost: "p1", commentAvatar: "user", commentUsername: "cuser1", comment: "Nice post!")
let comment2 = Comment(id: "c2", idUser: "u2", idPost: "p2", commentAvatar: "youssef", commentUsername: "cuser2", comment: "Great work!")

