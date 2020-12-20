//
//  UserModel.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/12/20.
//

import Foundation
class UserModel {
    var name: String = ""
    var phone: String = ""
    var profilePicture: String = ""
    var email: String = ""
    
    init(name: String, profilePicture: String) {
        self.name = name
        self.profilePicture = profilePicture
    }
}
