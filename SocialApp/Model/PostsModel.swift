//
//  PostsModel.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/9/20.
//
import Foundation
class PostsModel{
    var postID: String = ""
    var postPublisher: String = ""
    var postPublisherProfile: String = ""
    var bodyPost: String = ""
    var imagePost: String = ""
    var love: Int = 0
    var whoLovePost: [String] = [String]()
    
    init() {
    }
    
    init(postID: String, postPublisher: String,postPublisherProfile: String, bodyPost: String, imagePost: String, love: Int, whoLovePost: [String]) {
        self.postID = postID
        self.postPublisher = postPublisher
        self.postPublisherProfile = postPublisherProfile
        self.bodyPost = bodyPost
        self.imagePost = imagePost
        self.love = love
        self.whoLovePost = whoLovePost
    }
}
