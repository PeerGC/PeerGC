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
        BUTTON_TEXT_SIZE = (1.2/71) * UIScreen.main.bounds.height
        genericStructureViewControllerMetadataDelegate = self
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
        return .whereInProcess
    }
    
    func buttons() -> [DatabaseValue] {
        return [.hasntStartedLooking, .startedLookingNoPicks, .pickedNotApplying, .startedAppsButStuck, .doneWithApps]
    }
}
