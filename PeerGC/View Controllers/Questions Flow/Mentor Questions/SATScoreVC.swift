//
//  SATScoreVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class SATScoreVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
        textField?.keyboardType = .numberPad
    }
}

extension SATScoreVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Please enter your SAT score."
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return HelpMostVC()
    }
}

extension SATScoreVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        guard let text = textInput else { return "Invalid." }
        
        if text.isEmpty {
            return "Please enter a score."
        }
        
        GenericStructureViewController.sendToDatabaseData[DatabaseKey.testScore.name] = text
        
        return nil
    }
}
