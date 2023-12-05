//
//  Comment.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import Foundation
struct Comment : Decodable{
    let idUser: String?
    let idPost: String?
    let idComment: String?
    let commentAvatar: String?
    let commentUsername: String?
    let comment: String?
}

let comment1 = Comment(idUser: "c1", idPost: "u1", idComment: "p1", commentAvatar: "user", commentUsername: "cuser1", comment: "Nice post!")
let comment2 = Comment(idUser: "c2", idPost: "u2", idComment: "p2", commentAvatar: "youssef", commentUsername: "cuser2", comment: "Great work!")

