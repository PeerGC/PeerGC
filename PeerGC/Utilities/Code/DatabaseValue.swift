//
//  DatabaseValue.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/2/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

enum DatabaseValue: String, CaseIterable {
    //Account_Type
    case student = "Student"
    case mentor = "Mentor"
    
    //Gender
    case male = "Male"
    case female = "Female"
    case non_binary = "Non-Binary"
    case other = "Other"
    
    //Financial_Level
    case below_average = "Below Average"
    case average = "Average"
    case above_average = "Above Average"
    
    //LGBTQ
    case yes = "Yes"
    case no = "No"
    
    //Race
    case white = "White"
    case black_or_african_american = "Black / African American"
    case american_indian_or_alaska_native = "American Indian / Alaska Native"
    case asian = "Asian"
    case native_hawaiian_or_pacific_islander = "Native Hawaiian / Pacific Islander"
    
    //Did_Either_Of_Your_Parents_Attend_Higher_Education
    case partially_but_with_no_degree = "Partially but with no degree"
    
    //What_Year_Of_High_School and What_Year_Of_College
    case freshman = "Freshman"
    case sophomore = "Sophomore"
    case junior = "Junior"
    case senior = "Senior"
    
    //Which_Of_These_Interests_You_Most and What_Field_Of_Study_Are_You_Currently_Pursuing
    case humanities = "Humanities"
    case math_or_computer_science = "Math / Computer Science"
    case sciences = "Sciences"
    case business = "Business"
    case art_or_theatre = "Art / Theatre"
    
    //What_Are_You_Looking_For_From_A_Peer_Counselor
    case to_help_keep_me_on_track = "To help keep me on track"
    case to_provide_info_on_what_colleges_look_for = "To provide info on what colleges look for"
    case to_find_a_support_system_in_college = "To find a support system in college"
    case to_help_with_college_entrance_tests = "To help with college entrance tests"
    case to_help_with_essays = "To help with essays"
    
    //Where_Are_You_In_The_College_Application_Process
    case i_havent_started_looking = "I haven’t started looking"
    case i_started_looking_but_havent_picked_any_schools = "I started looking but haven’t picked any schools"
    case ive_picked_schools_but_havent_started_applying = "I've picked schools but haven't started applying"
    case ive_started_applications_but_im_stuck = "I've started applications but I'm stuck"
    case im_done_with_applications = "I'm done with applications"
    
    //How_Do_You_Feel_About_Applying
    case no_idea_what_im_doing = "No idea what I’m doing"
    case some_idea_of_where_to_start = "Some idea of where to start"
    case started_but_stuck = "Started but stuck"
    case pretty_good_idea_of_what_i_have_to_do = "Pretty good idea of what I have to do"
    case have_taken_all_known_steps = "Have taken all known steps"
    
    //What_Kind_Of_College_Are_You_Considering
    case local_community_colleges_only = "Local community colleges only"
    case four_year_city_colleges = "Four year city colleges"
    case trade_schools = "Trade schools"
    case top_tier_universities = "Top Tier Universities"
    case i_dont_know = "I don’t know"
    
    //Why_Do_You_Want_To_Go_To_College
    case get_out_of_current_living_situation = "Get out of current living situation"
    case specific_field_of_study = "Specific field of study"
    case to_get_a_high_paying_job = "To get a high paying job"
    case athletics = "Atheltics"
    
    //What_Was_Your_High_School_GPA
    case two_or_under = "2 or under"
    case between_two_and_three = "Between 2 and 3"
    case between_three_and_four = "Between 3 and 4"
    case four_or_higher = "4+"
    
    //Which_Test_Did_You_Use_For_Your_College_Application
    case sat = "SAT"
    case act = "ACT"
    case other_or_none = "Other / None"
    
    //Where_Can_You_Help_A_Student_Most
    case general_guidance_or_keeping_on_track = "General guidance / keeping on track"
    case info_on_what_colleges_look_for = "Info on what colleges look for"
    case finding_a_support_system_in_college = "Finding a support system in college"
    case college_entrance_tests = "College entrance tests"
    case application_essays = "Application essays"
    
    //Why_Did_You_Choose_The_College_You_Are_In
    case close_to_home = "Close to home"
    case big_name_school = "Big name school"
    case best_scholarship = "Best scholarship"
    case best_fit_with_your_religion_or_culture = "Best fit with your religion or culture"
    case something_else = "Something else"
    
    //What_Are_Your_Post_Grad_Aspirations
    case continued_study = "Continued study [masters / PhD / MD ...]"
    case atheltics  = "Athelitcs"
    case work_in_an_industry_related_to_your_major = "Work in an industry related to your major"
    case earn_money_with_your_degree = "Earn money with your degree"
    
    //Why_Do_You_Want_To_Be_A_Peer_Guidance_Counselor
    case you_wish_something_like_this_existed_for_you = "You wish something like this existed for you"
    case you_can_help_write_strong_essays = "You can help write strong essays"
    case you_scored_well_on_admissions_tests = "You scored well on admission tests"
    case you_can_socially_or_emotionally_support_mentees = "You can socially/emotionally support mentees"
    
    //What_Kind_Of_Student_Would_You_Be_Most_Excited_To_Mentor
    case financially_underprivileged = "Financially underprivileged"
    case lgbtq = "LGBTQ"
    case women_in_stem = "Women in STEM"
    case similar_cultural_or_religious_background_as_you = "Similar cultural/religious background as you"
    case similar_racial_background_as_you = "Similar racial background as you"
    
    //What_Kind_Of_Degree_Are_You_Currently_Pursuing
    case aa = "AA"
    case aa_for_transfer = "AA for transfer"
    case bachelor_of_art_or_science = "Bachelor of Art or Science"
    case trade_school_degree = "Trade school degree"
    
    //First_Language
    case english = "English"
    
    //Test_Score
    case not_availible = "N/A"
    
    //Relative_Status
    case matched
    
    var name: String {
        return String(describing: self)
    }
    
    init?(name: String) {
        for value in DatabaseValue.allCases {
            if value.name == name {
                self = value
                return
            }
        }
        return nil
    }
}
