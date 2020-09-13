//
//  DatabaseKey.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/2/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

enum DatabaseKey: CaseIterable {
    
    //Shared Question Keys
    case Account_Type
    case ZIP_Code
    case ZIP_Code_Median_Income
    case Financial_Level
    case Photo_URL
    case First_Name
    case Gender
    case LGBTQ
    case Race
    case Did_Either_Of_Your_Parents_Attend_Higher_Education
    case First_Language
    
    //Student Question Keys
    case What_Year_Of_High_School
    case Which_Of_These_Interests_You_Most
    case What_Are_You_Looking_For_From_A_Peer_Counselor
    case Where_Are_You_In_The_College_Application_Process
    case How_Do_You_Feel_About_Applying
    case What_Kind_Of_College_Are_You_Considering
    case Why_Do_You_Want_To_Go_To_College
    
    //Mentor Question Keys
    case What_Year_Of_College
    case What_Field_Of_Study_Are_You_Currently_Pursuing
    case What_College_Do_You_Attend
    case What_Was_Your_High_School_GPA
    case Which_Test_Did_You_Use_For_Your_College_Application
    case Test_Score
    case Where_Can_You_Help_A_Student_Most
    case Why_Did_You_Choose_The_College_You_Are_In
    case What_Are_Your_Post_Grad_Aspirations
    case Why_Do_You_Want_To_Be_A_Peer_Guidance_Counselor
    case What_Kind_Of_Student_Would_You_Be_Most_Excited_To_Mentor
    case What_Kind_Of_Degree_Are_You_Currently_Pursuing
    
    //Other Database Keys
    case Users
    case UID
    case Allow_List
    case Relative_Status
    case Token
    case Sender_ID
    case Sender_Display_Name
    case Message_ID
    case Date_Stamp
    case Content
    
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
