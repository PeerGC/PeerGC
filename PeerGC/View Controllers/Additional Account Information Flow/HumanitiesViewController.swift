//
//  HumanitiesViewController.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/13/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class HumanitiesViewController: UIViewController {
    
    
    @IBOutlet var specificationButtons: [DesignableButton]!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in specificationButtons {
            button.titleLabel!.font = button.titleLabel!.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
        }
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        AccountTypeViewController.data.interest = sender.titleLabel!.text
        
    }
    
}
