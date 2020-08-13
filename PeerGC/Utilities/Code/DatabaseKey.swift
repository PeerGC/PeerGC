//
//  DatabaseKey.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/2/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation

enum DatabaseKey: CaseIterable {
    case accountType
    case zipCode
    case zipCodeMedianIncome
    case photoURL
    case firstName
    case gender
    case lgbtq
    case race
    case parentsGoToCollege
    case schoolYear
    case interest
    case lookingFor
    case whereInProcess
    case feelAboutApplying
    case kindOfCollege
    case whyCollege
    case major
    case collegeName
    case highSchoolGPA
    case testTaken
    case testScore
    case helpMost
    case whyYourCollege
    case postGradAspirations
    case whyYouWantBeCounselor
    case whichStudentType
    case whichDegree
    case firstLanguage
    case users
    case uid
    case allowList
    case relativeStatus
    case token
    case senderID
    case senderDisplayName
    case messageID
    case dateStamp
    case content
    
    var name: String {
        return String(describing: self)
    }
    
    init?(name: String) {
        for key in DatabaseKey.allCases {
            if key.name == name {
                self = key
                return
            }
        }
        return nil
    }
}
