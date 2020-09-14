//
//  CollegeNameVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class CollegeNameVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
    }
}

extension CollegeNameVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What college do you attend?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return MajorVC()
    }
}

extension CollegeNameVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        
        guard let text = textInput else { return "Invalid." }
        
        if text.isEmpty {
            return "Please enter a college."
        }
        
        GenericStructureViewController.sendToDatabaseData[DatabaseKey.What_College_Do_You_Attend.name] = text
        
        return nil
    }
}
