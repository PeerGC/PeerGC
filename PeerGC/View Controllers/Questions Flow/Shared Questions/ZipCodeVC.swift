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
        metaDataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
        textField?.keyboardType = .numberPad
    }
}

extension ZipCodeVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Please enter your zip code."
    }
    
    func subtitle() -> String? {
        return "Your zip code is kept private. It is used in order to derive economic data as well as display your state to your peers."
    }
    
    func nextViewController() -> UIViewController? {
        return GenderVC()
    }
}

extension ZipCodeVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        
        guard let text = textInput else { return "Invalid." }
        
        if text.count > 5 {
            return "Please enter a valid zip code."
        }
        
        var zipCodeEdited = ""
        var hasStarted = false
        
        for char in text {
        
            if char != "0" {
                hasStarted = true
                zipCodeEdited += String(char)
            }
            
            if char == "0" {
                if hasStarted {
                    zipCodeEdited += String(char)
                }
            }
        }
        
        if !Utilities.zipCodeDoesExist(zipcode: zipCodeEdited) {
            return "Please enter a valid zip code."
        }
        
        GenericStructureViewController.sendToDatabaseData[DatabaseKey.zipCode.name] = zipCodeEdited
        GenericStructureViewController.sendToDatabaseData[DatabaseKey.zipCodeMedianIncome.name] = Utilities.getValueByZipCode(zipcode: zipCodeEdited)
        
        return nil
    }
}
