//
//  PlayersDBHelper.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-03-23.
//
// DB Helper class for players table operations
// -- Conceptually there are only plans for the players table
// -- however, additional tables may be added in the future

import Foundation

class PlayersDBHelper {
    
    static func printRecords() {
        let results = getPlayers()
        while results.next() {
            let s = results.string(forColumn: "ID")! + " " + results.string(forColumn: "name")!
            print(s)
        }
    }
    
    static func createPlayersTable() {
        DatabaseHelper.createTable(databaseName: DB_NAME, params: PARAMS)
    }
    
    static func dropPlayersTable () {
        DatabaseHelper.dropTable(databaseName: DB_NAME, params: PARAMS)
    }
    
    private static func getPlayers() -> FMResultSet {
        PARAMS.colString = "*"
        PARAMS.whereClause = ""
        PARAMS.orderByClause = "NAME"
        return DatabaseHelper.selectEntities(databaseName: DB_NAME, params: PARAMS)
    }
    
    static func getSelectedPlayer() -> Player! {
        PARAMS.colString = "ID, NAME, CHIPS, WINS, LOSSES, SELECTED"
        PARAMS.whereClause = "SELECTED = TRUE"
        let result = DatabaseHelper.selectEntities(databaseName: DB_NAME, params: PARAMS)
        
        while result.next() {
            let player = Player()
            player.ID = result.string(forColumn: "ID")!
            player.name = result.string(forColumn: "name")!
            player.chips = Int(result.int(forColumn: "chips"))
            player.wins = Int(result.int(forColumn: "wins"))
            player.losses = Int(result.int(forColumn: "losses"))
            player.selected = result.bool(forColumn: "selected")
            return player
        }
        return nil
    }
    
    static func getPlayerById(id: String) -> Player{
        PARAMS.colString = "ID, NAME, CHIPS, WINS, LOSSES, SELECTED"
        PARAMS.whereClause = "ID = '\(id)'"
        let result = DatabaseHelper.selectEntities(databaseName: DB_NAME, params: PARAMS)
        let player = Player()
        while result.next() {
            player.ID = result.string(forColumn: "ID")!
            player.name = result.string(forColumn: "name")!
            player.chips = Int(result.int(forColumn: "chips"))
            player.wins = Int(result.int(forColumn: "wins"))
            player.losses = Int(result.int(forColumn: "losses"))
            player.selected = result.bool(forColumn: "selected")
        }
        return player
    }
    
    static func getPlayersNSArray() -> NSArray {
        let results = getPlayers()
        var players = [Player]()
        while results.next() {
            let player = Player()
            player.ID = results.string(forColumn: "ID")!
            player.name = results.string(forColumn: "name")!
            player.chips = Int(results.int(forColumn: "chips"))
            player.wins = Int(results.int(forColumn: "wins"))
            player.losses = Int(results.int(forColumn: "losses"))
            player.selected = results.bool(forColumn: "selected")
            players.append(player)
        }
        return NSArray.init(array: players)
    }
    
    static func getPlayerCount() -> Int {
        let players = getPlayers()
        var count = 0
        while players.next() == true {
            count += 1
        }
        return count
    }
    
    static func insertPlayer(playerName: String) -> Player {
        let uuid = NSUUID().uuidString
        PARAMS.colString = "ID, NAME, CHIPS, WINS, LOSSES, SELECTED"
        PARAMS.valueString = "'\(uuid)', '\(playerName)', \(PLAYER_DEFAULTS)"
        DatabaseHelper.insertEntity(databaseName: DB_NAME,
                                  params: PARAMS)
        
        return getPlayerById(id: uuid)
    }
    
    static func updatePlayerName(player: Player) -> Player {
        PARAMS.colString = "NAME = '\(player.name)'"
        DatabaseHelper.updateEntity(databaseName: DB_NAME,
                                    params: PARAMS, id: player.ID)
        return getPlayerById(id: player.ID)
    }
    
    static func updatePlayerSelection(player: Player, isSelected: Bool) -> Player {
        PARAMS.colString = "SELECTED = \(isSelected)"
        DatabaseHelper.updateEntity(databaseName: DB_NAME,
                                    params: PARAMS, id: player.ID)
        return getPlayerById(id: player.ID)
    }
    
    static func updatePlayerChips(player: Player, chips: Int) -> Player {
        PARAMS.colString = "CHIPS = '\(chips)'"
        DatabaseHelper.updateEntity(databaseName: DB_NAME,
                                    params: PARAMS, id: player.ID)
        return getPlayerById(id: player.ID)
    }
    
    static func deletePlayer(id: String) {
        DatabaseHelper.deleteEntity(databaseName: DB_NAME,
                                    params: PARAMS, id: id)
    }
}
