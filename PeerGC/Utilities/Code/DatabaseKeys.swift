//
//  DatabaseKeys.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/2/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation

enum DatabaseKey {
    case accountType
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
    case highSchoolGPA
    case testTaken
    case helpMost
    case whyYourCollege
    case postGradAspirations
    case whichStudentType
    case whichDegree
    case firstLanguage
    
    var name: String {
        return String(describing: self)
    }
}
