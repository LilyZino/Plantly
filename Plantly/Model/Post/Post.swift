//
//  Post.swift
//  Plantly
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

class Post { 
    var id:String = ""
    var userName:String?
    var postText:String?
    var photo:String?
    var lastUpdate: Int64?
    
    init(id:String){
        self.id = id
    }
    
    init(id:String, name:String, text:String, photo:String) {
        self.id = id
        self.userName = name
        self.postText = text
        self.photo = photo
    }
}
