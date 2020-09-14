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
    @IBOutlet weak var messageAddMentorButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .secondarySystemGroupedBackground
        self.navigationController?.navigationBar.isTranslucent = false
        imageView.image = customCell!.imageView.image
        firstName.text = customCell!.data![DatabaseKey.First_Name.name]!
        setSectionText()
        
        firstName.font = firstName.font.withSize((2.8/71) * UIScreen.main.bounds.height)
        section1.font = section1.font.withSize((1.3/71) * UIScreen.main.bounds.height)
        section2.font = section2.font.withSize((1.3/71) * UIScreen.main.bounds.height)
        section3.font = section3.font.withSize((1.3/71) * UIScreen.main.bounds.height)
        messageAddMentorButton.titleLabel!.font = messageAddMentorButton.titleLabel!.font.withSize((1.5/71) * UIScreen.main.bounds.height)
        
        customCell?.setUpMessageAddMentorButton(button: messageAddMentorButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        super.viewWillAppear(animated)
    }
    
    @IBAction func addMentorMessageButtonPressed(_ sender: UIButton) {
        customCell?.addMentorMessageButtonPressed(sender)
    }
    
    func setSectionText() {
        let firstName = customCell!.data![DatabaseKey.First_Name.name]!
        
        if customCell!.data![DatabaseKey.Account_Type.name]! == DatabaseValue.student.name {
            //Section 1: Education
            let highSchoolYear = DatabaseValue(name: customCell!.data![DatabaseKey.What_Year_Of_High_School.name]!)!.rawValue
            let interest = DatabaseValue(name: customCell!.data![DatabaseKey.Which_Of_These_Interests_You_Most.name]!)!.rawValue
            
            var whereInProcess = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.Where_Are_You_In_The_College_Application_Process.name]!) {
                case .i_havent_started_looking:
                    whereInProcess = "has /bnot started/b looking"
                case .i_started_looking_but_havent_picked_any_schools:
                    whereInProcess = "has /bstarted looking/b but hasn't picked any schools"
                case .ive_picked_schools_but_havent_started_applying:
                    whereInProcess = "has /bpicked schools/b but hasn't began applying"
                case .ive_started_applications_but_im_stuck:
                    whereInProcess = "has /bstarted applications/b but is stuck"
                case .im_done_with_applications:
                    whereInProcess = "is /bdone/b with applications"
                default:
                    break
            }
            
            var sentenceString = """
            \n\(firstName) is a /b\(highSchoolYear)/b in high school,
            and is interested in /b\(interest)/b. ln regards to the college application process, \(firstName) \(whereInProcess).
            """
            
            section1.attributedText = Utilities.indigoLabelText(text: sentenceString)
            
            //Section 2: Questions
            var lookingFor = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.What_Are_You_Looking_For_From_A_Peer_Counselor.name]!) {
                case .to_help_keep_me_on_track:
                    lookingFor = "to help keep them /bon track/b"
                case .to_provide_info_on_what_colleges_look_for:
                    lookingFor = "to provide info on what /bcolleges look for/b"
                case .to_find_a_support_system_in_college:
                    lookingFor = "that can provide a /bsupport system/b in college"
                case .to_help_with_college_entrance_tests:
                    lookingFor = "to help with college /bentrance tests/b"
                case .to_help_with_essays:
                    lookingFor = "to help with /bessays/b"
                default:
                    break
            }
            
            var feelAboutApplying = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.How_Do_You_Feel_About_Applying.name]!) {
                case .no_idea_what_im_doing:
                    feelAboutApplying = "/bno idea/b what to do"
                case .some_idea_of_where_to_start:
                    feelAboutApplying = "/bsome idea/b of where to start"
                case .started_but_stuck:
                    feelAboutApplying = "/bstarted/b but is stuck"
                case .pretty_good_idea_of_what_i_have_to_do:
                    feelAboutApplying = "/bpretty good idea/b of what to do"
                case .have_taken_all_known_steps:
                    feelAboutApplying = "/btaken all known steps/b"
                default:
                    break
            }
            
            let kindOfCollege = DatabaseValue(name: customCell!.data![DatabaseKey.How_Do_You_Feel_About_Applying.name]!) == .i_dont_know ?
                "/bdoesn't know/b what types of colleges they're interested in" :
                "is interested in /b\(DatabaseValue(name: customCell!.data![DatabaseKey.What_Kind_Of_College_Are_You_Considering.name]!)!.rawValue)/b"
            
            var whyCollege = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.Why_Do_You_Want_To_Go_To_College.name]!) {
                case .get_out_of_current_living_situation:
                    whyCollege = "to /bget out/b from their current living situation"
                case .specific_field_of_study:
                    whyCollege = "to pursue a specific field of /bstudy/b"
                case .to_get_a_high_paying_job:
                    whyCollege = "to get a high paying job"
                case .atheltics:
                    whyCollege = "to compete in /bathletics/b"
                case .i_dont_know:
                    whyCollege = "for an /bunknown reason/b"
                default:
                    break
            }
            
            let firstGenerationStatus = DatabaseValue(name: customCell!.data![DatabaseKey.Did_Either_Of_Your_Parents_Attend_Higher_Education.name]!)
            let firstGenerationString = firstGenerationStatus == .yes ? "won't" : "will"
            let firstLanguge = customCell!.data![DatabaseKey.First_Language.name]!
            
            sentenceString = """
            \(firstName) is looking for someone /b\(lookingFor)/b, and has \(feelAboutApplying). \(firstName) \(kindOfCollege),
            \(whyCollege). \(firstName) /b\(firstGenerationString)/b be a first generation college student,
            and their first language is /b\(firstLanguge)/b.
            """
            
            section2.attributedText = Utilities.indigoLabelText(text: sentenceString)
            
            //Section 3: Demographics
            let state = customCell!.state.text!
            let zipCodeMedianIncomeClassification = DatabaseValue(name: customCell!.data![DatabaseKey.Financial_Level.name]!)!.rawValue
            let gender = DatabaseValue(name: customCell!.data![DatabaseKey.Gender.name]!)!.rawValue
            let lgbtqStatus = DatabaseValue(name: customCell!.data![DatabaseKey.LGBTQ.name]!)
            let lgbtqString = lgbtqStatus == .yes ? "does" : "does not"
            let race = DatabaseValue(name: customCell!.data![DatabaseKey.Race.name]!)!.rawValue
            
            sentenceString = """
            \(firstName) lives in /b\(state)/b in a zipcode with a(n) /b\(zipCodeMedianIncomeClassification)/b median income. \
            \(firstName)'s gender is /b\(gender)/b, \(firstName) /b\(lgbtqString)/b identify as LGBTQ, \
            and \(firstName)'s race is /b\(race)/b.
            """
            
            section3.attributedText = Utilities.indigoLabelText(text: sentenceString)
            
        } else if customCell!.data![DatabaseKey.Account_Type.name]! == DatabaseValue.mentor.name {
            
            //Section 1: Education
            let collegeYear = DatabaseValue(name: customCell!.data![DatabaseKey.What_Year_Of_College.name]!)!.rawValue
            let degree = DatabaseValue(name: customCell!.data![DatabaseKey.What_Kind_Of_Degree_Are_You_Currently_Pursuing.name]!)!.rawValue
            let major = DatabaseValue(name: customCell!.data![DatabaseKey.What_Field_Of_Study_Are_You_Currently_Pursuing.name]!)!.rawValue
            let university = customCell!.data![DatabaseKey.What_College_Do_You_Attend.name]!
            let testTaken = DatabaseValue(name: customCell!.data![DatabaseKey.Which_Test_Did_You_Use_For_Your_College_Application.name]!)!.rawValue
            let testScore = customCell!.data![DatabaseKey.Test_Score.name]!
            let highSchoolGPA = DatabaseValue(name: customCell!.data![DatabaseKey.What_Was_Your_High_School_GPA.name]!)!.rawValue
            
            var sentenceString = """
            \n\(firstName) is a /b\(collegeYear)/b pursuing a /b\(degree)/b degree \
            as a /b\(major)/b major at /b\(university)/b.
            """
            let toAppend = testTaken == DatabaseValue.other_or_none.name ? " \(firstName) did not take any college entrance exams. " :
                                        " \(firstName) applied to college with a /b\(testScore)/b on the /b\(testTaken)/b exam. "
            sentenceString.append(toAppend + "In high school, \(firstName) had a GPA that was /b\(highSchoolGPA)/b. ")
            
            section1.attributedText = Utilities.indigoLabelText(text: sentenceString)
            
            //Section 2: Other
            let firstGenerationStatus = DatabaseValue(name: customCell!.data![DatabaseKey.Did_Either_Of_Your_Parents_Attend_Higher_Education.name]!)
            let firstGenerationString = firstGenerationStatus == .yes ? "isn't" : "is"
            let firstLanguge = customCell!.data![DatabaseKey.First_Language.name]!
            
            var whyTheirCollegeReasoning = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.Why_Did_You_Choose_The_College_You_Are_In.name]!) {
                case .close_to_home:
                    whyTheirCollegeReasoning = "it was /bClose to Home/b"
                case .big_name_school:
                    whyTheirCollegeReasoning = "it was a /bBig Name School/b"
                case .best_scholarship:
                    whyTheirCollegeReasoning = "it offered the /bBest Scholarship/b"
                case .best_fit_with_your_religion_or_culture:
                    whyTheirCollegeReasoning = "it had the best fit with their /bReligion/b and/or /bCulture/b"
                case .something_else:
                    whyTheirCollegeReasoning = "of an /bUnspecified Reason/b"
                default:
                    break
            }
            
            var postGradAspiration = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.What_Are_Your_Post_Grad_Aspirations.name]!) {
                case .continued_study:
                    postGradAspiration = " perform /bContinued Study/b [masters, PHD, MD, etc...]."
                case .atheltics:
                    postGradAspiration = " compete in /bAthletics/b."
                case .work_in_an_industry_related_to_your_major:
                    postGradAspiration = " /bWork in an Industry/b related to their major."
                case .earn_money_with_your_degree:
                    postGradAspiration = " /bEarn Money/b with their degree."
                case .i_dont_know:
                    postGradAspiration = " ... /bContinue Living Life/b!"
                default:
                    break
            }
            
            var helpMost = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.Where_Can_You_Help_A_Student_Most.name]!) {
                case .general_guidance_or_keeping_on_track:
                    helpMost = "/bgeneral guidance/b and keeping you on track"
                case .info_on_what_colleges_look_for:
                    helpMost = "/binfo/b on what colleges look for"
                case .finding_a_support_system_in_college:
                    helpMost = "finding a /bsupport system/b in college"
                case .college_entrance_tests:
                    helpMost = "college entrance /btests/b"
                case .application_essays:
                    helpMost = "application /bessays/b"
                default:
                    break
            }
            
            sentenceString = """
            \(firstName) chose their college because \(whyTheirCollegeReasoning). \
            \(firstName) is most capable of helping with \(helpMost). \
            After they graduate from college, \(firstName) aspires to\(postGradAspiration) \
            \(firstName) /b\(firstGenerationString)/b a first generation college student, \
            and their first language is /b\(firstLanguge)/b.
            """
            
            section2.attributedText = Utilities.indigoLabelText(text: sentenceString)
            
            //Section 3: Demographics & other...
            
            var whyTheyWantToBeCounselor = ""
            
            switch DatabaseValue(name: customCell!.data![DatabaseKey.Why_Do_You_Want_To_Be_A_Peer_Guidance_Counselor.name]!) {
                case .you_wish_something_like_this_existed_for_you:
                    whyTheyWantToBeCounselor = "they wish they knew /bsomething like this/b existed for them"
                case .you_can_help_write_strong_essays:
                    whyTheyWantToBeCounselor = "they can help write /bstrong essays/b"
                case .you_scored_well_on_admissions_tests:
                    whyTheyWantToBeCounselor = "they /bscored well/b on admissions tests"
                case .you_can_socially_or_emotionally_support_mentees:
                    whyTheyWantToBeCounselor = "they can /bsocially and emotionally/b support you"
                case .something_else:
                    whyTheyWantToBeCounselor = "of an /bUnspecified Reason/b"
                default:
                    break
            }
            
            let state = customCell!.state.text!
            let zipCodeMedianIncomeClassification = DatabaseValue(name: customCell!.data![DatabaseKey.Financial_Level.name]!)!.rawValue
            let gender = DatabaseValue(name: customCell!.data![DatabaseKey.Gender.name]!)!.rawValue
            let lgbtqStatus = DatabaseValue(name: customCell!.data![DatabaseKey.LGBTQ.name]!)
            let lgbtqString = lgbtqStatus == .yes ? "does" : "does not"
            let race = DatabaseValue(name: customCell!.data![DatabaseKey.Race.name]!)!.rawValue
            
            sentenceString = """
            \(firstName) wants to be your counselor because \(whyTheyWantToBeCounselor). \
            \(firstName) lives in /b\(state)/b in a zipcode with a(n) /b\(zipCodeMedianIncomeClassification)/b median income. \
            \(firstName)'s gender is /b\(gender)/b, \(firstName) /b\(lgbtqString)/b identify as LGBTQ, \
            and \(firstName)'s race is /b\(race)/b.
            """
            
            section3.attributedText = Utilities.indigoLabelText(text: sentenceString)
        }
    }
    
}
