//
//  firebaseModel.swift
//  Plantly
//
//  Created by JC 1 on 13/03/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebase {
    
    func add(_ post: Post, _ callback: @escaping ()->Void){
        let db = Firestore.firestore()
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("posts").addDocument(data: post.toJson(), completion: { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                callback()
            }
        })
    }
    
    func getAllPosts(since:Int64, _ callback:@escaping ([Post]?)->Void){
        let db = Firestore.firestore()
        db.collection("posts").order(by: "lastUpdate", descending: true).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                
                var data = [Post]();
                for document in querySnapshot!.documents {
                    if let ts = document.data()["lastUpdate"] as? Timestamp{
                        let tsDate = ts.dateValue();
                        print("\(tsDate)");
                        let tsDouble = tsDate.timeIntervalSince1970;
                        print("\(tsDouble)");
                    }
                    data.append(Post(json: document.data()));
                }
                
                callback(data);
            }
        };
    }
    
    func getAllUsers(_ callback:@escaping ([User]?)->Void){
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                
                var data = [User]();
                for document in querySnapshot!.documents {
                    data.append(User(json: document.data()));
                }
                
                callback(data);
            }
        };
    }
    
    func getMyPosts(since:Int64, _ callback:@escaping ([Post]?)->Void){
        let db = Firestore.firestore()
        db.collection("posts").whereField("userName", isEqualTo: userModel.userInstance.currentUser.userName).order(by: "lastUpdate", descending: true).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                
                var data = [Post]();
                for document in querySnapshot!.documents {
                    if let ts = document.data()["lastUpdate"] as? Timestamp{
                        let tsDate = ts.dateValue();
                        print("\(tsDate)");
                        let tsDouble = tsDate.timeIntervalSince1970;
                        print("\(tsDouble)");
                    }
                    data.append(Post(json: document.data()));
                    
                }
                callback(data);
            }
        };
    }
    
    func addUser(_ user: User){
        let db = Firestore.firestore()
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: user.toJson(), completion: { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        })
    }
    
    func editUser(_ user: User){
        let db = Firestore.firestore()
        db.collection("users").whereField("id", isEqualTo: user.id).getDocuments { (querySnapshot, err) in
            db.collection("users").document((querySnapshot?.documents[0].documentID)!).setData(user.toJson(), completion: { err in
                if let err = err {
                    print("Error editing document: \(err)")
                } else {
                    print("Document updated")
                }
            })
        }
        
    }
    
    func editPost(_ post: Post, _ callback: @escaping ()->Void){
        let db = Firestore.firestore()
        db.collection("posts").whereField("id", isEqualTo: post.id).getDocuments { (querySnapshot, err) in
            db.collection("posts").document((querySnapshot?.documents[0].documentID)!).setData(post.toJson(), completion: { err in
                if let err = err {
                    print("Error editing document: \(err)")
                } else {
                    print("Document updated")
                    callback()
                }
            })
        }
        
    }
    
    func deletePost(_ post: Post, _ callback: @escaping ()->Void){
        let db = Firestore.firestore()
        db.collection("posts").whereField("id", isEqualTo: post.id).getDocuments { (querySnapshot, err) in
            db.collection("posts").document((querySnapshot?.documents[0].documentID)!).delete() { err in
                if let err = err {
                    print("Error editing document: \(err)")
                } else {
                    print("Document updated")
                    callback()
                }
            }
        }
    }
}
