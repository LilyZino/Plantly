//
//  SQLModel.swift
//  Plantly
//
//  Created by admin on 22/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

class SQLModel{
    static let instance = SQLModel()
    
    var database: OpaquePointer? = nil
    
    init() {
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            print(path)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK{
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
        }
        create()
        Post.create(database: database);
    }
    
    deinit {
        sqlite3_close_v2(database);
    }
    
    private func create(){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS LAST_UPDATE_DATE (NAME TEXT PRIMARY KEY, DATE DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    func setLastUpdate(_ name:String, _ lastUpdated:Int64){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO LAST_UPDATE_DATE( NAME, DATE) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
            sqlite3_bind_int64(sqlite3_stmt, 2, lastUpdated);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("date updated")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func getLastUpdateDate(name:String)->Int64{
        var date:Int64 = 0;
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * FROM LAST_UPDATE_DATE where NAME like ?;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                date = sqlite3_column_int64(sqlite3_stmt,1)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return date
    }
}
