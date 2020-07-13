//
//  AccountTypeSpecificationViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/9/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

struct Data {
    var accountType: String?
    var zipCode: String?
    var value: Double?
    var interest: String?
    var gender: String?
    var race: String?
}

class AccountTypeViewController: UIViewController {
    
    static var data = Data(
        accountType: nil,
        zipCode: nil,
        interest: nil,
        gender: nil,
        race: nil
    )
    
    @IBOutlet var specificationButtons: [DesignableButton]!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for button in specificationButtons {
            button.titleLabel!.font = button.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        }
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        AccountTypeViewController.data.accountType = sender.titleLabel!.text
        
    }
    
}
