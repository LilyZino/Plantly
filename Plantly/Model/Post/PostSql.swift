//
//  PostSql.swift
//  Plantly
//
//  Created by admin on 11/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation


extension Post{
    static func create(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (POST_ID TEXT PRIMARY KEY, USERNAME TEXT, POSTTEXT TEXT, PHOTO TEXT)", nil, nil, &errormsg)
        if (res != 0){
            print("error creating table")
            return
        }
    }
    
    func add(){
        
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(SQLModel.instance.database, "INSERT OR REPLACE INTO POSTS (POST_ID, USERNAME, POSTTEXT, PHOTO) VALUES (?,?,?,?);", -1,
                               &sqlite3_stmt, nil) == SQLITE_OK){
            let id = self.id.cString(using: .utf8)
            let userName = self.userName!.cString(using: .utf8)
            let postText = self.postText!.cString(using: .utf8)
            let photo = self.photo!.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, userName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, postText,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, photo,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllPosts()->[Post]{
        
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Post]()
        if (sqlite3_prepare_v2(SQLModel.instance.database,"SELECT * from POSTS;", -1, &sqlite3_stmt, nil) == SQLITE_OK) {
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let pid = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let name = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let text = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let photo = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                data.append(Post(id:pid, name:name, text:text, photo:photo))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    func delete(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(SQLModel.instance.database, "DELETE FROM POSTS WHERE POST_ID = ?;", -1,
                               &sqlite3_stmt, nil) == SQLITE_OK){
            let id = self.id.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("row deleted succefully")
            } else {
                print("delete statement failed")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return SQLModel.instance.setLastUpdate("POSTS", lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return SQLModel.instance.getLastUpdateDate(name: "POSTS")
    }
}
