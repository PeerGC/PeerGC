//
//  FirstGenerationVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class FirstGenerationVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension FirstGenerationVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Did either of your parents attend higher education?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        if GenericStructureViewController.sendToDatabaseData[DatabaseKey.Account_Type.name] == DatabaseValue.student.name {
            return HighSchoolYearVC()
        } else if GenericStructureViewController.sendToDatabaseData[DatabaseKey.Account_Type.name] == DatabaseValue.mentor.name {
            return CollegeYearVC()
        } else {
            return nil
        }
    }
}

extension FirstGenerationVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .Did_Either_Of_Your_Parents_Attend_Higher_Education
    }
    
    func buttons() -> [DatabaseValue] {
        return [.yes, .no, .partially]
    }
}
