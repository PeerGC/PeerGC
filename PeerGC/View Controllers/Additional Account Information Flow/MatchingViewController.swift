//
//  MatchingViewController.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/1/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MatchingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        let functions = Functions.functions()
        
        functions.httpsCallable("setCards").call(["uid": Auth.auth().currentUser!.uid]) { (result, error) in
          if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
             
            }
            // ...
          }
          if let text = (result?.data as? [String: Any])?["success"] as? Bool {
            print(text)
            self.transitionToHome()
          }
        }
    }
    
    func transitionToHome() {
        
        let window: UIWindow = (UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first)!
        
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        
        
        view.window?.rootViewController = homeViewController
        
        // A mask of options indicating how you want to perform the animations.
        let options: UIView.AnimationOptions = .transitionFlipFromRight

        // The duration of the transition animation, measured in seconds.
        let duration: TimeInterval = 0.3

        // Creates a transition animation.
        // Though `animations` is optional, the documentation tells us that it must not be nil. ¯\_(ツ)_/¯
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
        
    }
}
