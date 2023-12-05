//
//  Comment.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import Foundation
struct Comment: Decodable , Identifiable{
    
    var id: String { idComment }
    let idComment: String
    let idUser: String?
    let idPost: String?
    let commentAvatar: String?
    let commentUsername: String?
    let comment: String?
    
   
}

let comment1 = Comment( idComment: "p1",idUser: "c1", idPost: "u1", commentAvatar: "user", commentUsername: "cuser1", comment: "Nice post!")
let comment2 = Comment( idComment: "p2",idUser: "c2", idPost: "u2", commentAvatar: "youssef", commentUsername: "cuser2", comment: "Great work!")

