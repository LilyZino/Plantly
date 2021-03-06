//
//  FirebaseStorage.swift
//  Plantly
//
//  Created by admin on 10/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CommonCrypto

class FirebaseStorage {
    
    static func saveImage(image:UIImage, callback:@escaping (String)->Void){
        let storageRef = Storage.storage().reference(forURL:
            "gs://plantly-68ed8.appspot.com")
        
        let data = image.jpegData(compressionQuality: 0.8)
        
        let imageName:String = "image" + self.getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate()) + String(Int.random(in: 1..<99999999999));
        let imageRef = storageRef.child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    static func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
}

