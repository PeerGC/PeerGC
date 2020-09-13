//
//  HighSchoolScoresVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class HighSchoolScoresVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
    
    override func selectionButtonTextHandler(text: String) {
        if text == DatabaseValue.other_or_none.rawValue {
            GenericStructureViewController.sendToDatabaseData[DatabaseKey.Test_Score.name] = DatabaseValue.not_availible.name
        }
        
        super.selectionButtonTextHandler(text: text)
    }

}

extension HighSchoolScoresVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Which test did you use for your college application?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        let testTaken = GenericStructureViewController.sendToDatabaseData[databaseIdentifier().name]!
        
        if testTaken == DatabaseValue.sat.name {
            return SATScoreVC()
        } else if testTaken == DatabaseValue.act.name {
            return ACTScoreVC()
        } else {
            return HelpMostVC()
        }
    }
}

extension HighSchoolScoresVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .Which_Test_Did_You_Use_For_Your_College_Application
    }
    
    func buttons() -> [DatabaseValue] {
        return [.sat, .act, .other_or_none]
    }
}
