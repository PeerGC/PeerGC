//
//  ViewController.swift
//  FBex
//
//  Created by AJ Radik on 12/11/19.
//  Copyright © 2019 AJ Radik. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class EntranceViewController: UIViewController {

    @IBOutlet weak var continueWithEmail: DesignableButton!
    @IBOutlet weak var continueWithGoogle: DesignableButton!
    
    //edit
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        continueWithEmail.titleLabel!.font = continueWithEmail.titleLabel!.font.withSize( (1.4/71) * UIScreen.main.bounds.height)
        continueWithGoogle.titleLabel!.font = continueWithGoogle.titleLabel!.font.withSize( (1.4/71) * UIScreen.main.bounds.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func continueWithGoogleButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
    
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 1.0
        }
        
    }
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 0.6
        }
        
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 1.0
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

extension EntranceViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
        if error != nil {
        // ...
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
            // ...
            return
          }
          // User is signed in
          // ...
            
            print("signed in with google!")
            
             // Transition to home
                   let uid = Auth.auth().currentUser!.uid
                   let docRef = Firestore.firestore().collection("users").document(uid)

                   docRef.getDocument { (document, error) in
                       if let document = document, document.exists {
                           print("Document EXISTS")
                           self.transitionToHome()
                       } else {
                           print("Document does not exist")
                           self.performSegue(withIdentifier: "goToFurther", sender: self)
                       }
                   }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}
