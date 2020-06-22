//
//  userFirebase.swift
//  Plantly
//
//  Created by admin on 20/06/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import Firebase

extension User {
    convenience init(json:[String:Any]){
        let id = json["id"] as! String;
        self.init(id:id)
        
        userName = json["userName"] as! String;
        email = json["email"] as! String;
        password = json["password"] as! String;
        userImage = json["userImage"] as? String;
        let ts = json["lastUpdate"] as? Timestamp
        lastUpdate = ts?.seconds
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["id"] = id
        json["userName"] = userName
        json["email"] = email
        json["password"] = password
        json["userImage"] = userImage
        json["lastUpdate"] = FieldValue.serverTimestamp()
        return json;
    }
}
