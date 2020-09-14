//
//  FeelAboutApplyingVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class FeelAboutApplyingVC: GenericStructureViewController {
    override func viewDidLoad() {
        buttonTextSize = (1.4/71) * UIScreen.main.bounds.height
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension FeelAboutApplyingVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "How do you feel about applying?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return KindOfCollegeVC()
    }
}

extension FeelAboutApplyingVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .How_Do_You_Feel_About_Applying
    }
    
    func buttons() -> [DatabaseValue] {
        return [.no_idea_what_im_doing, .some_idea_of_where_to_start, .started_but_stuck, .pretty_good_idea_of_what_i_have_to_do, .have_taken_all_known_steps]
    }
}
