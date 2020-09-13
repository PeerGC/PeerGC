//
//  LookingForVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class LookingForVC: GenericStructureViewController {
    
    override func viewDidLoad() {
        buttonTextSize = (1.3/71) * UIScreen.main.bounds.height
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension LookingForVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What are you looking for from a peer counselor?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return WhereInProcessVC()
    }
}

extension LookingForVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .What_Are_You_Looking_For_From_A_Peer_Counselor
    }
    
    func buttons() -> [DatabaseValue] {
        return [.to_help_keep_me_on_track, .to_provide_info_on_what_colleges_look_for, .finding_a_support_system_in_college, .to_help_with_college_entrance_tests, .to_help_with_essays]
    }
}
