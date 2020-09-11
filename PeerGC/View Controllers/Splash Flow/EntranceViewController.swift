//
//  ViewController.swift
//  FBex
//
//  Created by AJ Radik on 12/11/19.
//  Copyright © 2019 AJ Radik. All rights reserved.
//

import UIKit
import Firebase

class EntranceViewController: UIViewController {

    @IBOutlet weak var studentButton: DesignableButton!
    @IBOutlet weak var mentorButton: DesignableButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentButton.titleLabel!.font = studentButton.titleLabel!.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
        mentorButton.titleLabel!.font = mentorButton.titleLabel!.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
        
        versionLabel.font = versionLabel.font.withSize( (1.4/71) * UIScreen.main.bounds.height)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.text = "Version " + version + " Build " + build + " " + Utilities.getBuildConfiguration() + " Alpha"
        }
        
        performSegue(withIdentifier: "goToHowItWorks", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func studentButtonPressed(_ sender: Any) {
        GenericStructureViewController.sendToDatabaseData[DatabaseKey.accountType.name] = DatabaseValue.student.name
        performSegue(withIdentifier: "goToSignInProviders", sender: nil)
    }
    
    @IBAction func mentorButtonPressed(_ sender: Any) {
        GenericStructureViewController.sendToDatabaseData[DatabaseKey.accountType.name] = DatabaseValue.mentor.name
        performSegue(withIdentifier: "goToSignInProviders", sender: nil)
    }
    
}
