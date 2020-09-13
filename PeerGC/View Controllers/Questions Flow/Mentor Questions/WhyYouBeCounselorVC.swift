//
//  WhyYouBeCounselorVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class WhyYouBeCounselorVC: GenericStructureViewController {
    override func viewDidLoad() {
        buttonTextSize = (1.2/71) * UIScreen.main.bounds.height
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension WhyYouBeCounselorVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Why do you want to be a peer guidance counselor?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return WhichStudentTypeVC()
    }
}

extension WhyYouBeCounselorVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .Why_Do_You_Want_To_Be_A_Peer_Guidance_Counselor
    }
    
    func buttons() -> [DatabaseValue] {
        return [.you_wish_something_like_this_existed_for_you,
                .you_can_help_write_strong_essays,
                .you_scored_well_on_admissions_tests,
                .you_can_socially_or_emotionally_support_mentees,
                .something_else]
    }
}
