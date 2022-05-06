//
//  QueryParams.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-03-23.
//
// 

import Foundation

class QueryParams {
    var tableName = ""
    var colString = ""
    var whereClause = ""
    var orderByClause = ""
    var tableSigString = ""
    var valueString = ""
    
    init(tableName: String, colString: String, whereClause: String, orderByClause: String, valueString: String, tableSigString: String) {
        self.tableName = tableName
        self.colString = colString
        self.whereClause = whereClause
        self.orderByClause = orderByClause
        self.tableSigString = tableSigString
        self.valueString = valueString
    }
}
