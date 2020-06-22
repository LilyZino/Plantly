//
//  PostFirebase.swift
//  Plantly
//
//  Created by admin on 11/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import Firebase

extension Post {
    convenience init(json:[String:Any]) {
        let id = json["id"] as! String;
        self.init(id:id)

        userName = json["userName"] as? String;
        postText = json["postText"] as? String;
        photo = json["photo"] as? String;
        let ts = json["lastUpdate"] as? Timestamp
        lastUpdate = ts?.seconds
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["id"] = id
        json["userName"] = userName
        json["postText"] = postText
        json["photo"] = photo
        json["lastUpdate"] = FieldValue.serverTimestamp()
        return json;
    }
}
