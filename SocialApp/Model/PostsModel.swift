//
//  PostsModel.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/9/20.
//
import Foundation
class PostsModel{
    var postID: String = ""
    var bodyPost: String = ""
    var imagePost: String = ""
    var love: Int = 0
    var userID: String = ""
    var whoLovePost: [String] = [String]()
    
    init() {
    }
    init(postID: String, bodyPost: String, imagePost: String, love: Int, userID: String ,whoLovePost: [String]) {
        self.postID = postID
        self.bodyPost = bodyPost
        self.imagePost = imagePost
        self.love = love
        self.userID = userID
        self.whoLovePost = whoLovePost
    }
}
