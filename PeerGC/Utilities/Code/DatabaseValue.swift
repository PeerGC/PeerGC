//
//  DatabaseValue.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/2/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation

enum DatabaseValue: String {
    //accountType
    case student = "Student"
    case mentor = "Mentor"
    
    //gender
    case male = "Male"
    case female = "Female"
    case nonBinary = "Non-Binary"
    case other = "Other"
    
    //lgbtq
    case yes = "Yes"
    case no = "No"
    
    //race
    case white = "White"
    case blackAfricanAmerican = "Black / African American"
    case americanIndianAlaskaNative = "American Indian / Alaska Native"
    case asian = "Asian"
    case nativeHawaiianPacificIslander = "Native Hawaiian / Pacific Islander"
    
    //parentsGoToCollege
    case partially = "Partially but with no degree"
    
    //schoolYear
    case freshman = "Freshman"
    case sophomore = "Sophomore"
    case junior = "Junior"
    case senior = "Senior"
    
    //interest
    case humanities = "Humanities"
    case mathComputerScience = "Math / Computer Science"
    case sciences = "Sciences"
    case business = "Business"
    case artTheatre = "Art / Theatre"
    
    //lookingFor
    case keepOnTrack = "To help keep me on track"
    case infoOnCollegeWants = "To provide info on what colleges look for"
    case supportSystem = "To find a support system in college"
    case entranceTests = "To help with college entrance tests"
    case essays = "To help with essays"
    
    //whereInProcess
    case hasntStartedLooking = "I haven’t started looking"
    case startedLookingNoPicks = "I started looking but haven’t picked any schools"
    case pickedNotApplying = "I've picked schools but haven't started applying"
    case startedAppsButStuck = "I've started applications but I'm stuck"
    case doneWithApps = "I'm done with applications"
    
    //feelAboutApplying
    case noIdea = "No idea what I’m doing"
    case someIdea = "Some idea of where to start"
    case startedButStuck = "Started but stuck"
    case prettyGoodIdea = "Pretty good idea of what I have to do"
    case takenAllKnownSteps = "Have taken all known steps"
    
    //kindOfCollege
    case localCommunityColleges = "Local community colleges only"
    case fourYearCityColleges = "Four year city colleges"
    case tradeSchools = "Trade schools"
    case topTierUniversites = "Top Tier Universities"
    case dontKnow = "I don’t know"
    
    //whyCollege
    case getOutOfLivingSituation = "Get out of current living situation"
    case specificFieldOfStudy = "Specific field of study"
    case highPayingJob = "To get a high paying job"
    case athletics = "Atheltics"
    
    //highSchoolGPA
    case twoOrUnder = "2 or under"
    case betweenTwoAndThree = "Between 2 and 3"
    case betweenThreeAndFour = "Between 3 and 4"
    case fourPlus = "4+"
    
    //testTaken
    case sat = "SAT"
    case act = "ACT"
    case otherNone = "Other / None"
    
    //helpMost
    case generalGuidance = "General guidance / keeping on track"
    case infoCollegeLookFor = "Info on what colleges look for"
    case findingSupportSystem = "Finding a support system in college"
    case collegeEntranceTests = "College entrance tests"
    case applicationEssays = "Application essays"
    
    //whyYourCollege
    case closeToHome = "Close to home"
    case bigNameSchool = "Big name school"
    case bestScholarship = "Best scholarship"
    case bestReligionCultureFit = "Best fit with your religion or culture"
    case somethingElse = "Something else"
    
    //postGradAspirations
    case continuedStudy = "Continued study [masters / PhD / MD ...]"
    case atheltics  = "Athelitcs"
    case relatedIndustry = "Work in an industry related to your major"
    case earnMoney = "Earn money with your degree"
    
    //whichStudentType
    case financiallyUnderprivileged = "Financially underprivileged"
    case lgbtq = "LGBTQ"
    case womenInStem = "Women in STEM"
    case similarCultureReligion = "Similar cultural/religious background as you"
    case similarRacialBackground = "Similar racial background as you"
    
    //whichDegree
    case aa = "AA"
    case aaForTransfer = "AA for transfer"
    case bachelorArtScience = "Bachelor of Art or Science"
    case tradeSchoolDegree = "Trade school degree"
    
    //firstLangauge
    case english = "English"
    
    //testScore
    case na = "N/A"
    
    var name: String {
        return String(describing: self)
    }
}
