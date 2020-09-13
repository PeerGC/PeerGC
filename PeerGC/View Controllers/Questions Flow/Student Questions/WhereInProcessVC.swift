//
//  WhereInProcessVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class WhereInProcessVC: GenericStructureViewController {
    override func viewDidLoad() {
        buttonTextSize = (1.2/71) * UIScreen.main.bounds.height
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension WhereInProcessVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Where you are in the college application process?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return FeelAboutApplyingVC()
    }
}

extension WhereInProcessVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .Where_Are_You_In_The_College_Application_Process
    }
    
    func buttons() -> [DatabaseValue] {
        return [.i_havent_started_looking,
                .i_started_looking_but_havent_picked_any_schools,
                .ive_picked_schools_but_havent_started_applying,
                .ive_started_applications_but_im_stuck,
                .im_done_with_applications]
    }
}
