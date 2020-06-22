//
//  userModel.swift
//  Plantly
//
//  Created by admin on 20/06/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import UIKit

class userModel {
    
    static let userInstance = userModel()
    var sqlmodel:SQLModel = SQLModel()
    var fbmodel:ModelFirebase = ModelFirebase()
    
    private init(){
        SQLModel.instance.setLastUpdate("USERS", 12)
    }
    
    func add(_ user:User){
        fbmodel.addUser(user)
    }
    
    func edit(_ user:User){
        fbmodel.editUser(user)
    }
    
    func getAllUsers(_ callback:@escaping ([User]?)->Void){
        
        //get the cloud updates since the local update date
        fbmodel.getAllUsers() { (data) in
            var lud:Int64 = 0;
            //insert update to the local db
            for user in data!{
                user.add()
                if (user.lastUpdate != nil) {
                    if user.lastUpdate! > lud {lud = user.lastUpdate!}
                }
            }
            //update the students local last update date
            User.setLastUpdate(lastUpdated: lud)
            print("Last Update Date: \(lud)")
            // get the complete student list
            let finalData = User.getAllUsers()
            callback(finalData);
        }
        
    }
    
    func getMyPosts(_ callback:@escaping ([Post]?)->Void){
        let lud = Post.getLastUpdateDate();
        fbmodel.getMyPosts(since: lud, callback);
    }
    
    func getUserPhoto(_ userName:String, _ callback:@escaping (String)->Void){
        fbmodel.getAllUsers() { (data) in
            for user in data!{
                if(userName == user.userName) {
                    callback(user.userImage ?? "")
                }
            }
        }
    }
    
    func getLastID(_ callback: @escaping (String)->Void){
        var lastId:String = "0";
        fbmodel.getAllUsers { (data) in
            for user in data!{
                if user.id >= lastId {lastId = user.id}
            }
            callback(lastId)
        }
    }
    
    var logedIn = false
    var currentUser = User(id: "")
    func isLogedIn()->Bool {
        return logedIn
    }
    
    func login(email:String, pwd:String, callback:@escaping(Bool)->Void) {
        fbmodel.getAllUsers { (data) in
            for user in data!{
                if user.email == email {
                    if user.password == pwd {
                        self.logedIn = true
                        self.currentUser = User(id: user.id, name: user.userName, email: user.email, pwd: user.password, img: user.userImage ?? "")
                    }
                }
            }
            callback(self.logedIn)
        }
    }
    
    func logout() {
        logedIn = false
        currentUser = User(id: "")
    }
    
    func register(username:String, email:String, pwd:String, callback:@escaping(Bool)->Void) {
        var isExists = false
        var cUser = User(id: "")
        fbmodel.getAllUsers { (data) in
            for user in data!{
                if user.email == email {
                    print("email alredy exists")
                    isExists = true
                } else if user.userName == username {
                    print("user name alredy exists")
                    isExists = true
                } else {
                    cUser = user
                }
            }
            if (isExists == false) {
                self.logedIn = true
                self.getLastID() { newId in
                    let ID = Int64(newId)! + 1
                    self.fbmodel.addUser(User(id: String(ID), name: username, email: email, pwd: pwd))
                    self.currentUser = User(id: cUser.id, name: cUser.userName, email: cUser.email, pwd: cUser.password, img: cUser.userImage ?? "")
                }
                
            }
            callback(self.logedIn)
        }
    }
}
