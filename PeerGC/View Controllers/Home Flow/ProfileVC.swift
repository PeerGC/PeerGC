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
    
    var customCell: CustomCell?
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var section1: UILabel!
    @IBOutlet weak var section2: UILabel!
    @IBOutlet weak var section3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .secondarySystemGroupedBackground
        self.navigationController?.navigationBar.isTranslucent = false
        imageView.image = customCell!.imageView.image
        firstName.text = customCell!.data!["firstName"]!
        setSectionText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    func setSectionText() {
        let firstName = customCell!.data!["firstName"]!
        
        if DatabaseParser.getAnswerIDFromDisplayText(displayText: "Student") == customCell!.data!["accountType"]! {
            
        }
            
        else if DatabaseParser.getAnswerIDFromDisplayText(displayText: "Mentor") == customCell!.data!["accountType"]! {
            
            //Section 1: Education
            let collegeYear = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["schoolYear"]!)
            let degree = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["whichDegree"]!)
            let major = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["major"]!)
            let university = "University"
            let testTaken = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["testTaken"]!)
            let testScore = customCell!.data!["testScore"]!
            let highSchoolGPA = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["highSchoolGPA"]!)
            
            var sentenceString = "\n\(firstName) is a /b\(collegeYear)/b pursuing a /b\(degree)/b degree as a  /b\(major)/b major at /b\(university)/b. "
            
            if testTaken == "Other / None" {
                sentenceString.append("\(firstName) did not take any college entrance exams. ")
            }
            
            else {
                sentenceString.append("\(firstName) applied to college with a /b\(testScore)/b on the /b\(testTaken)/b exam. ")
            }
            
            sentenceString.append("In high school, \(firstName) had a GPA that was /b\(highSchoolGPA)/b. ")
            
            section1.attributedText = Utilities.blueText(text: sentenceString)
            
            //Section 2: Demographics
            
        }
    }
    
}
