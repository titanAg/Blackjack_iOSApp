//
//  DatabaseVariables.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-03-23.
//

import Foundation

let DB_NAME = "blackjack"
let PLAYER_DEFAULTS = "500, 0, 0, false"
let PARAMS = QueryParams(tableName: "PLAYERS",
                         colString: "",
                         whereClause: "",
                         orderByClause: "",
                         valueString: "",
                         tableSigString: "ID TEXT PRIMARY KEY, name TEXT, CHIPS INTEGER, WINS INTEGER, LOSSES INTEGER, SELECTED BOOLEAN")
