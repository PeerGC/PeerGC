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
    @IBOutlet weak var messageButton: DesignableButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .secondarySystemGroupedBackground
        self.navigationController?.navigationBar.isTranslucent = false
        imageView.image = customCell!.imageView.image
        firstName.text = customCell!.data!["firstName"]!
        setSectionText()
        
        firstName.font = firstName.font.withSize((2.8/71) * UIScreen.main.bounds.height)
        section1.font = section1.font.withSize((1.5/71) * UIScreen.main.bounds.height)
        section2.font = section2.font.withSize((1.5/71) * UIScreen.main.bounds.height)
        section3.font = section3.font.withSize((1.5/71) * UIScreen.main.bounds.height)
        messageButton.titleLabel!.font = messageButton.titleLabel!.font.withSize((1.5/71) * UIScreen.main.bounds.height)
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
            let toAppend = testTaken == "Other / None" ? "\(firstName) did not take any college entrance exams. " : "\(firstName) applied to college with a /b\(testScore)/b on the /b\(testTaken)/b exam. "
            sentenceString.append(toAppend + "In high school, \(firstName) had a GPA that was /b\(highSchoolGPA)/b. ")
            
            section1.attributedText = Utilities.blueText(text: sentenceString)
            
            //Section 2: Other
            let firstGenerationStatus = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["parentsGoToCollege"]!)
            let firstGenerationString = firstGenerationStatus == "Yes" ? "isn't" : "is"
            let firstLanguge = customCell!.data!["firstLanguage"]!
            
            var whyTheirCollegeReasoning = ""
            
            switch customCell!.data!["whyYourCollege"] {
                case "68":
                whyTheirCollegeReasoning = "it was /bClose to Home/b"
                case "69":
                whyTheirCollegeReasoning = "it was a /bBig Name School/b"
                case "70":
                whyTheirCollegeReasoning = "it offered the /bBest Scholarship/b"
                case "71":
                whyTheirCollegeReasoning = "it had the best fit with their /bReligion/b and/or /bCulture/b"
                case "72":
                whyTheirCollegeReasoning = "of an /bUnspecified Reason/b"
                default:
                break
            }
            
            var postGradAspiration = ""
            
            switch customCell!.data!["postGradAspirations"] {
                case "73":
                postGradAspiration = " perform /bContinued Study/b [masters, PHD, MD, etc...]."
                case "74":
                postGradAspiration = " compete in /bAthletics/b."
                case "75":
                postGradAspiration = " /bWork in an Industry/b related to their major."
                case "76":
                postGradAspiration = " /bEarn Money/b with their degree."
                case "77":
                postGradAspiration = " ... /bContinue Living Life/b!"
                default:
                break
            }
            
            sentenceString = "\(firstName) chose their college because \(whyTheirCollegeReasoning). After they graduate from college, \(firstName) aspires to \(postGradAspiration) \(firstName) /b\(firstGenerationString)/b a first generation college student, and their first language is /b\(firstLanguge)/b."
            
            section2.attributedText = Utilities.blueText(text: sentenceString)
            
            //Section 3: Demographics
            let state = customCell!.cityState.text!
            let zipCodeValue = Utilities.getValueByZipCode(zipcode: customCell!.data!["zipCode"]!)!
            var zipCodeMedianIncomeClassification = zipCodeValue < "50000" ? "Below Average" : "Average"
            zipCodeMedianIncomeClassification = zipCodeValue > "100000" ? "Above Average" : "Average"
            let gender = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["gender"]!)
            let lgbtqStatus = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["lgbtq"]!)
            let lgbtqString = lgbtqStatus == "Yes" ? "does" : "does not"
            let race = DatabaseParser.getDisplayTextFromAnswerID(answerID: customCell!.data!["race"]!)
            
            sentenceString = "\(firstName) lives in /b\(state)/b in a zipcode with a(n) /b\(zipCodeMedianIncomeClassification)/b median income. \(firstName)'s gender is /b\(gender)/b, \(firstName) /b\(lgbtqString)/b identify as LGBTQ, and \(firstName)'s race is /b\(race)/b."
            
            section3.attributedText = Utilities.blueText(text: sentenceString)
        }
    }
    
}
