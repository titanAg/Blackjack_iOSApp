//
//  DatabaseHelper.swift
//  Blackjack
//
//  Created by Kyle on 2022-03-21.
//
// Reusable DB Helper class
// -- Provides interface with DB and ensures DB operations are limited

import Foundation

class DatabaseHelper {
    static let filemgr = FileManager.default
    static let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
    static var databasePath = { (db: String) in return dirPaths[0].appendingPathComponent(db + ".db").path}
    
    static func createTable(databaseName: String, params: QueryParams) {
        let path = databasePath(databaseName)
        if !filemgr.fileExists(atPath: path as String) {
            let db = FMDatabase(path: path as String)
            let sql = "CREATE TABLE IF NOT EXISTS " + params.tableName + " (" + params.tableSigString + ")"
            print("Executing: " + sql)
            if (db.open()) {
                if !(db.executeStatements(sql)) {
                    print("Error: \(db.lastErrorMessage())")
                }
                db.close()
            } else {
                print("Error: \(db.lastErrorMessage())")
            }
        }
    }
    
    // For debugging only
    static func dropTable(databaseName: String, params: QueryParams) {
        let path = databasePath(databaseName)
        if filemgr.fileExists(atPath: path as String) {
            let db = FMDatabase(path: path as String)
            let sql = "DROP TABLE " + params.tableName
            print("Executing: " + sql)
            if (db.open()) {
                if !(db.executeStatements(sql)) {
                    print("Error: \(db.lastErrorMessage())")
                }
                db.close()
            } else {
                print("Error: \(db.lastErrorMessage())")
            }
        }
    }

    static func insertEntity(databaseName: String, params: QueryParams) {
        let path = databasePath(databaseName)
        let db = FMDatabase(path: path as String)
        if (db.open()){
            let sql = "INSERT INTO " + params.tableName + "(" + params.colString + ") VALUES (" + params.valueString + ")"
            print("Executing: " + sql)
            let result = db.executeUpdate(sql, withArgumentsIn: [])
            if !result {
                print("Error: \(db.lastErrorMessage())")
            }
        }
    }
    
    static func selectEntities(databaseName: String, params: QueryParams) -> FMResultSet {
        let path = databasePath(databaseName)
        let db = FMDatabase(path: path as String)
        if (db.open()) {
            let whereClause = (params.whereClause.isEmpty ? "" : "WHERE \(params.whereClause)")
            let orderByClause = (params.orderByClause.isEmpty ? "" : "ORDER BY \(params.orderByClause)")
            let sql = "SELECT \(params.colString) FROM \(params.tableName) \(whereClause) \(orderByClause)"
            //print("Exectuing: " + sql)
            let results:FMResultSet? = db.executeQuery(sql, withArgumentsIn: [])
            return results ?? FMResultSet.init()
        } else {
            print("Error: \(db.lastErrorMessage())")
            return FMResultSet.init()
        }
    }
    
    static func updateEntity(databaseName: String, params: QueryParams, id: String) {
        let path = databasePath(databaseName)
        let db = FMDatabase(path: path as String)
        if (db.open()) {
            let sql = "UPDATE \(params.tableName) SET \(params.colString) WHERE ID = '\(id)'"
            print("Exectuing: " + sql)
            _ = db.executeUpdate(sql, withArgumentsIn: [])
            db.close()
        } else {
            print("Error: \(db.lastErrorMessage())")
        }
    }
    
    static func deleteEntity(databaseName: String, params: QueryParams, id: String) {
        let path = databasePath(databaseName)
        let db = FMDatabase(path: path as String)
        if (db.open()){
            let sql = "DELETE FROM \(params.tableName) WHERE ID = '\(id)'"
            print("Executing: " + sql)
            let result = db.executeUpdate(sql, withArgumentsIn: [])
            if !result {
                print("Error: \(db.lastErrorMessage())")
            }
        }
    }
}
