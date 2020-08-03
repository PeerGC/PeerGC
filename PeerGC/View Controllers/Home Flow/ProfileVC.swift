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
        firstName.text = customCell!.data![DatabaseKey.firstName.name]!
        setSectionText()
        
        firstName.font = firstName.font.withSize((2.8/71) * UIScreen.main.bounds.height)
        section1.font = section1.font.withSize((1.4/71) * UIScreen.main.bounds.height)
        section2.font = section2.font.withSize((1.4/71) * UIScreen.main.bounds.height)
        section3.font = section3.font.withSize((1.4/71) * UIScreen.main.bounds.height)
        messageButton.titleLabel!.font = messageButton.titleLabel!.font.withSize((1.5/71) * UIScreen.main.bounds.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    func setSectionText() {
        let firstName = customCell!.data![DatabaseKey.firstName.name]!
        
        if customCell!.data![DatabaseKey.accountType.name]! == DatabaseValue.student.name {
            //Section 1: Education
            let highSchoolYear = DatabaseValue(name: customCell!.data![DatabaseKey.schoolYear.name]!)!.rawValue
            let interest = DatabaseValue(name: customCell!.data![DatabaseKey.interest.name]!)!.rawValue
            
            var whereInProcess = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.whereInProcess.name]!) {
                case .hasntStartedLooking:
                    whereInProcess = "has /bnot started/b looking"
                case .startedLookingNoPicks:
                    whereInProcess = "has /bstarted looking/b but hasn't picked any schools"
                case .pickedNotApplying:
                    whereInProcess = "has /bpicked schools/b but hasn't began applying"
                case .startedAppsButStuck:
                    whereInProcess = "has /bstarted applications/b but is stuck"
                case .doneWithApps:
                    whereInProcess = "is /bdone/b with applications"
                default:
                    break
            }
            
            var sentenceString = "\n\(firstName) is a /b\(highSchoolYear)/b in high school, and is interested in /b\(interest)/b. ln regards to the college application process, \(firstName) has \(whereInProcess)."
            
            section1.attributedText = Utilities.blueLabelText(text: sentenceString)
            
            //Section 2: Questions
            var lookingFor = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.lookingFor.name]!) {
                case .keepOnTrack:
                    lookingFor = "to help keep them /bon track/b"
                case .infoOnCollegeWants:
                    lookingFor = "to provide info on what /bcolleges look for/b"
                case .supportSystem:
                    lookingFor = "that can provide a /bsupport system/b in college"
                case .entranceTests:
                    lookingFor = "to help with college /bentrance tests/b"
                case .essays:
                    lookingFor = "to help with /bessays/b"
                default:
                    break
            }
            
            var feelAboutApplying = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.feelAboutApplying.name]!) {
                case .noIdea:
                    feelAboutApplying = "/bno idea/b what to do"
                case .someIdea:
                    feelAboutApplying = "/bsome idea/b of where to start"
                case .startedButStuck:
                    feelAboutApplying = "/bstarted/b but is stuck"
                case .prettyGoodIdea:
                    feelAboutApplying = "/bpretty good idea/b of what to do"
                case .takenAllKnownSteps:
                    feelAboutApplying = "/btaken all known steps/b"
                default:
                    break
            }
            
            let kindOfCollege = customCell!.data!["feelAboutApplying"] == "45" ? "/bdoesn't know/b what types of colleges they're interested in" : "is interested in /b\(DatabaseValue(name: customCell!.data![DatabaseKey.kindOfCollege.name]!)!.rawValue)/b"
            
            var whyCollege = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.whyCollege.name]!) {
                case .getOutOfLivingSituation:
                    whyCollege = "to /bget out/b from their current living situation"
                case .specificFieldOfStudy:
                    whyCollege = "to pursue a specific field of /bstudy/b"
                case .highPayingJob:
                    whyCollege = "to get a high paying job"
                case .atheltics:
                    whyCollege = "to compete in /bathletics/b"
                case .dontKnow:
                    whyCollege = "for an /bunknown reason/b"
                default:
                    break
            }
            
            let firstGenerationStatus = DatabaseValue(name: customCell!.data![DatabaseKey.parentsGoToCollege.name]!)
            let firstGenerationString = firstGenerationStatus == .yes ? "won't" : "will"
            let firstLanguge = customCell!.data![DatabaseKey.firstLanguage.name]!
            
            sentenceString = "\(firstName) is looking for someone /b\(lookingFor)/b, and has \(feelAboutApplying). \(firstName) \(kindOfCollege), \(whyCollege). \(firstName) /b\(firstGenerationString)/b be a first generation college student, and their first language is /b\(firstLanguge)/b."
            
            section2.attributedText = Utilities.blueLabelText(text: sentenceString)
            
            //Section 3: Demographics
            let state = customCell!.state.text!
            let zipCodeValue = customCell!.data![DatabaseKey.zipCodeMedianIncome.name]!
            var zipCodeMedianIncomeClassification = zipCodeValue < "50000" ? "Below Average" : "Average"
            zipCodeMedianIncomeClassification = zipCodeValue > "100000" ? "Above Average" : "Average"
            let gender = DatabaseValue(name: customCell!.data![DatabaseKey.gender.name]!)!.rawValue
            let lgbtqStatus = DatabaseValue(name: customCell!.data![DatabaseKey.lgbtq.name]!)
            let lgbtqString = lgbtqStatus == .yes ? "does" : "does not"
            let race = DatabaseValue(name: customCell!.data![DatabaseKey.race.name]!)!.rawValue
            
            sentenceString = "\(firstName) lives in /b\(state)/b in a zipcode with a(n) /b\(zipCodeMedianIncomeClassification)/b median income. \(firstName)'s gender is /b\(gender)/b, \(firstName) /b\(lgbtqString)/b identify as LGBTQ, and \(firstName)'s race is /b\(race)/b."
            
            section3.attributedText = Utilities.blueLabelText(text: sentenceString)
            
        }
    
        else if customCell!.data![DatabaseKey.accountType.name]! == DatabaseValue.mentor.name {
            
            //Section 1: Education
            let collegeYear = DatabaseValue(name: customCell!.data![DatabaseKey.schoolYear.name]!)!.rawValue
            let degree = DatabaseValue(name: customCell!.data![DatabaseKey.whichDegree.name]!)!.rawValue
            let major = DatabaseValue(name: customCell!.data![DatabaseKey.major.name]!)!.rawValue
            let university = "University"
            let testTaken = DatabaseValue(name: customCell!.data![DatabaseKey.testTaken.name]!)!.rawValue
            let testScore = customCell!.data![DatabaseKey.testScore.name]!
            let highSchoolGPA = DatabaseValue(name: customCell!.data![DatabaseKey.highSchoolGPA.name]!)!.rawValue
            
            var sentenceString = "\n\(firstName) is a /b\(collegeYear)/b pursuing a /b\(degree)/b degree as a  /b\(major)/b major at /b\(university)/b. "
            let toAppend = testTaken == "Other / None" ? "\(firstName) did not take any college entrance exams. " : "\(firstName) applied to college with a /b\(testScore)/b on the /b\(testTaken)/b exam. "
            sentenceString.append(toAppend + "In high school, \(firstName) had a GPA that was /b\(highSchoolGPA)/b. ")
            
            section1.attributedText = Utilities.blueLabelText(text: sentenceString)
            
            //Section 2: Other
            let firstGenerationStatus = DatabaseValue(name: customCell!.data![DatabaseKey.parentsGoToCollege.name]!)
            let firstGenerationString = firstGenerationStatus == .yes ? "isn't" : "is"
            let firstLanguge = customCell!.data![DatabaseKey.firstLanguage.name]!
            
            var whyTheirCollegeReasoning = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.whyYourCollege.name]!) {
                case .closeToHome:
                    whyTheirCollegeReasoning = "it was /bClose to Home/b"
                case .bigNameSchool:
                    whyTheirCollegeReasoning = "it was a /bBig Name School/b"
                case .bestScholarship:
                    whyTheirCollegeReasoning = "it offered the /bBest Scholarship/b"
                case .bestReligionCultureFit:
                    whyTheirCollegeReasoning = "it had the best fit with their /bReligion/b and/or /bCulture/b"
                case .somethingElse:
                    whyTheirCollegeReasoning = "of an /bUnspecified Reason/b"
                default:
                    break
            }
            
            var postGradAspiration = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.postGradAspirations.name]!) {
                case .continuedStudy:
                    postGradAspiration = " perform /bContinued Study/b [masters, PHD, MD, etc...]."
                case .atheltics:
                    postGradAspiration = " compete in /bAthletics/b."
                case .relatedIndustry:
                    postGradAspiration = " /bWork in an Industry/b related to their major."
                case .earnMoney:
                    postGradAspiration = " /bEarn Money/b with their degree."
                case .dontKnow:
                    postGradAspiration = " ... /bContinue Living Life/b!"
                default:
                    break
            }
            
            sentenceString = "\(firstName) chose their college because \(whyTheirCollegeReasoning). After they graduate from college, \(firstName) aspires to \(postGradAspiration) \(firstName) /b\(firstGenerationString)/b a first generation college student, and their first language is /b\(firstLanguge)/b."
            
            section2.attributedText = Utilities.blueLabelText(text: sentenceString)
            
            //Section 3: Demographics
            let state = customCell!.state.text!
            let zipCodeValue = customCell!.data![DatabaseKey.zipCodeMedianIncome.name]!
            var zipCodeMedianIncomeClassification = zipCodeValue < "50000" ? "Below Average" : "Average"
            zipCodeMedianIncomeClassification = zipCodeValue > "100000" ? "Above Average" : "Average"
            let gender = DatabaseValue(name: customCell!.data![DatabaseKey.gender.name]!)!.rawValue
            let lgbtqStatus = DatabaseValue(name: customCell!.data![DatabaseKey.lgbtq.name]!)
            let lgbtqString = lgbtqStatus == .yes ? "does" : "does not"
            let race = DatabaseValue(name: customCell!.data![DatabaseKey.race.name]!)!.rawValue
            
            sentenceString = "\(firstName) lives in /b\(state)/b in a zipcode with a(n) /b\(zipCodeMedianIncomeClassification)/b median income. \(firstName)'s gender is /b\(gender)/b, \(firstName) /b\(lgbtqString)/b identify as LGBTQ, and \(firstName)'s race is /b\(race)/b."
            
            section3.attributedText = Utilities.blueLabelText(text: sentenceString)
        }
    }
    
}
