//
//  Profile.swift
//  Plantly
//
//  Created by admin on 11/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

class User {
    var id:String = ""
    var userName:String=""
    var email:String=""
    var password:String=""
    var userImage:String?
    var lastUpdate: Int64?
    
    init(id:String){
        self.id = id
    }
    
    init(id:String, name:String, email:String, pwd:String) {
        self.id = id
        self.userName = name
        self.email = email
        self.password = pwd
    }
    
    init(id:String, name:String, email:String, pwd:String, img:String) {
        self.id = id
        self.userName = name
        self.email = email
        self.password = pwd
        self.userImage = img
    }
}
