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
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var googleIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    //edit
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        continueWithEmail.titleLabel!.font = continueWithEmail.titleLabel!.font.withSize( (1.4/71) * UIScreen.main.bounds.height)
        continueWithGoogle.titleLabel!.font = continueWithGoogle.titleLabel!.font.withSize( (1.4/71) * UIScreen.main.bounds.height)
        
        versionLabel.font = versionLabel.font.withSize( (1.4/71) * UIScreen.main.bounds.height)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.text = "Version " + version + " Build " + build + " Alpha"
        }
        
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
    
}

extension EntranceViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
      // ...
        if error != nil {
        // ...
        return
      }
        
        startIndicator()

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
                    Firestore.firestore().collection("users").document(uid).collection("allowList").getDocuments(completion: { (querySnapshot, error) in
                        print("QuerySnapshot Count: \(querySnapshot!.count)")
                        Utilities.loadHomeScreen()
                    })
                } else {
                    print("Document does not exist")
                    self.nextViewControllerHandler(viewController: AccountTypeVC())
                }
            }
            
            
        }
        
    }
    
    func nextViewControllerHandler(viewController: UIViewController) {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
        if let navigationController = keyWindow?.rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func cleanUp() {
        continueWithEmail.isHidden = false
        continueWithGoogle.isHidden = false
        activityIndicator.isHidden = true
        emailIcon.isHidden = false
        googleIcon.isHidden = false
    }
    
    func startIndicator() {
        continueWithEmail.isHidden = true
        continueWithGoogle.isHidden = true
        activityIndicator.isHidden = false
        emailIcon.isHidden = true
        googleIcon.isHidden = true
    }
    
}
