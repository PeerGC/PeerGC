//
//  ProfileVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/1/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {
    
    var data: [String: String]?
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var section1: UILabel!
    @IBOutlet weak var section2: UILabel!
    @IBOutlet weak var section3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .secondarySystemGroupedBackground
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    func loadSectionText() {
        if DatabaseParser.getAnswerIDFromDisplayText(displayText: "Student") == data!["accountType"]! {
            
        }
            
        else if DatabaseParser.getAnswerIDFromDisplayText(displayText: "Mentor") == data!["accountType"]! {
            
            
            
            let firstName = data!["firstName"]!
            let schoolYear = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["schoolYear"]!)
            let degree = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["whichDegree"]!)
            let major = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["major"]!)
            let university = "University"
            let testScore = data!["testScore"]!
            let testTaken = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["testTaken"]!)
            let firstGenerationStatus = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["parentsGoToCollege"]!)
            var firstGenerationString = ""
            
            if firstGenerationStatus == "Yes" {
                firstGenerationString = "isn't"
            }
            
            else {
                firstGenerationString = "is"
            }
            
            let firstLanguge = data!["firstLanguage"]!
            
            let sentenceString = "\(firstName) is a /b\(schoolYear)/b pursuing a /b\(degree)/b degree as a  /b\(major)/b major at /b\(university)/b. \(firstName) applied to college with a /b\(testScore)/b on the /b\(testTaken)/b exam. \(firstName) /b\(firstGenerationString)/b a first generation college student, and their first language is /b\(firstLanguge)/b."
            
            
        }
    }
    
}
