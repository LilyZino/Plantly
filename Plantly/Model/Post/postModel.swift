//
//  postModel.swift
//  Plantly
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import UIKit

class postsModel {
    
    static let postsInstance = postsModel()
    var sqlmodel:SQLModel = SQLModel()
    var fbmodel:ModelFirebase = ModelFirebase()
    
    private init(){
        SQLModel.instance.setLastUpdate("POSTS", 12)
    }
    
    func add(_ post:Post, _ callback: @escaping ()->Void){
        fbmodel.add(post, callback)
    }
    
    func getAllPosts(_ callback:@escaping ([Post]?)->Void){
        
        //get the local last update date
        let lud = Post.getLastUpdateDate();
        
        //get the cloud updates since the local update date
        fbmodel.getAllPosts(since:lud) { (data) in
            var lud:Int64 = 0;
            //insert update to the local db
            for post in data!{
                post.add()
                if (post.lastUpdate != nil) {
                    if post.lastUpdate! > lud {lud = post.lastUpdate!}
                }
            }
            //update the posts local last update date
            Post.setLastUpdate(lastUpdated: lud)
            print("Last Update Date: \(lud)")
            // get the complete posts list
            let finalData = Post.getAllPosts()
            callback(finalData);
        }
        
    }
    
    func editPost(post:Post, _ callback: @escaping ()->Void){
        fbmodel.editPost(post, callback)
        post.add()
    }
    
    func deletePost(post:Post, _ callback: @escaping ()->Void){
        fbmodel.deletePost(post, callback)
        post.delete()
    }
    
    func saveImage(image:UIImage, callback: @escaping (String)->Void){
        FirebaseStorage.saveImage(image: image, callback: callback)
    }
    
    func getLastID(_ callback: @escaping (String)->Void){
        let lud = Post.getLastUpdateDate();
        var lastId:String = "0";
        fbmodel.getAllPosts(since:lud) { (data) in
            for post in data!{
                if post.id >= lastId {lastId = post.id}
            }
            callback(lastId)
        }
    }
}
