//
//  OtherFirstLanguageVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class OtherFirstLanguageVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
    }
}

extension OtherFirstLanguageVC: GenericStructureViewControllerMetadataDelegate {    
    func title() -> String {
        return "Please fill in your first language."
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return MatchingVC()
    }
}

extension OtherFirstLanguageVC: TextFieldDelegate {    
    func continuePressed(textInput: String?) -> String? {
        return nil
    }
}
