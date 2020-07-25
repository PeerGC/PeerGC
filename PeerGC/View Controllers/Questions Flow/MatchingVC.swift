//
//  MatchingVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/25/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class MatchingVC: GenericStructureViewController {
    override func viewDidLoad() {
        topBuffer = -60
        genericStructureViewControllerMetadataDelegate = self
        activityIndicatorDelegate = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension MatchingVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Matching You Now..."
    }
    
    func subtitle() -> String? {
        return "Please wait a minute while our matching algorithm matches you with your peers..."
    }
    
    func nextViewController() -> UIViewController? {
        return UIViewController()
    }
}

extension MatchingVC: ActivityIndicatorDelegate {
    
}
