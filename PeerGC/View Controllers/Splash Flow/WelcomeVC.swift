//
//  WelcomeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/5/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet var stepsLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = titleLabel.font.withSize((3.0/71) * UIScreen.main.bounds.height)
        subTitleLabel.font = subTitleLabel.font.withSize((1.4/71) * UIScreen.main.bounds.height)
        
        for step in stepsLabels {
            step.font = step.font.withSize((1.4/71) * UIScreen.main.bounds.height)
        }
    }
    
    @IBAction func letsStartButtonPressed(_ sender: Any) {
        Utilities.logError(customMessage: "Test Error Logging In Crashlytics", customCode: -814)
        fatalError()
        //self.dismiss(animated: true, completion: nil)
    }
    
}
