//
//  DatabaseSheetParser.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/1/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation

class DatabaseParser {
    
    static var databaseSheet: [[String]]?
    
    static func getAnswerIDsFromQuestionID(questionID: String) -> [String] {
        initializeDatabaseSheet()
        var toReturn: [String] = []
        
        for row in DatabaseParser.databaseSheet! {
            if row[0] == questionID {
                toReturn.append(row[1])
            }
        }
        
        return toReturn
    }
    
    static func getDisplayTextFromAnswerID(answerID: String) -> String {
        initializeDatabaseSheet()
        
        for row in DatabaseParser.databaseSheet! {
            if row[1] == answerID {
                return row[2]
            }
        }
        
        return "nil"
    }
    
    static func getAnswerIDFromDisplayText(displayText: String) -> String {
        initializeDatabaseSheet()
        
        for row in DatabaseParser.databaseSheet! {
            if row[2] == displayText {
                return row[1]
            }
        }
        
        return "nil"
    }
    
    static func initializeDatabaseSheet() {
        if databaseSheet == nil {
            let path: String? = Bundle.main.path(forResource: "DatabaseParseSheet", ofType: "csv")
            let dataString = Utilities.getDataString(path: path)
            DatabaseParser.databaseSheet = Utilities.csv(data: dataString!)
        }
    }
}
