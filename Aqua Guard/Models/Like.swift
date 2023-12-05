//
//  Like.swift
//  Aqua Guard
//
//  Created by Youssef Farhat on 29/11/2023.
//

import Foundation

struct Like : Decodable{
    
    let idLike : String?
    let likeAvatar: String?
    let likeUsername: String?
    
}
let like1 = Like(idLike:"1",likeAvatar: "yousseff", likeUsername: "Youssef Farhat")
let like2 = Like(idLike:"2",likeAvatar: "user", likeUsername: "Malek Labidi")

