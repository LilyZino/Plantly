//
//  userSql.swift
//  Plantly
//
//  Created by admin on 20/06/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation


extension User{
    static func create(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS (USER_ID TEXT PRIMARY KEY, USERNAME TEXT, EMAIL TEXT, PASSWORD TEXT, USERIMAGE TEXT)", nil, nil, &errormsg)
        if (res != 0){
            print("error creating table")
            return
        }
    }
    
    func add(){
        
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(SQLModel.instance.database, "INSERT OR REPLACE INTO USERS (USER_ID, USERNAME, EMAIL, PASSWORD, USERIMAGE) VALUES (?,?,?,?,?);", -1,
                               &sqlite3_stmt, nil) == SQLITE_OK){
            let id = self.id.cString(using: .utf8)
            let userName = self.userName.cString(using: .utf8)
            let email = self.email.cString(using: .utf8)
            let password = self.password.cString(using: .utf8)
            let userImage = self.userImage!.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, userName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, email,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, password,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, userImage,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new user row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllUsers()->[User]{
        
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [User]()
        if (sqlite3_prepare_v2(SQLModel.instance.database,"SELECT * from USERS;", -1, &sqlite3_stmt, nil) == SQLITE_OK) {
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let pid = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let name = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let email = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let password = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let photo = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                data.append(User(id: pid, name: name, email: email, pwd: password, img: photo))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return SQLModel.instance.setLastUpdate("USERS", lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return SQLModel.instance.getLastUpdateDate(name: "USERS")
    }
}
