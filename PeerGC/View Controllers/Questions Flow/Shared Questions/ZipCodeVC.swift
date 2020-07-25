//
//  ZipCodeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class ZipCodeVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
    }
}

extension ZipCodeVC: GenericStructureViewControllerMetadataDelegate {
    func databaseIdentifier() -> String {
        return "zipCode"
    }
    
    func title() -> String {
        return "Please enter your zip code."
    }
    
    func subtitle() -> String? {
        return "Your zip code is kept private. It is used in order to derive economic data as well as display your state to your peers."
    }
    
    func nextViewController() -> UIViewController {
        return GenderVC()
    }
}

extension ZipCodeVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        return nil
    }
    
    func placeHolderText() -> String {
        return "Zip Code"
    }
}
