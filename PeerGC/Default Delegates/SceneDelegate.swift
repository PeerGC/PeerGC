//
//  SceneDelegate.swift
//  FBex
//
//  Created by AJ Radik on 12/11/19.
//  Copyright © 2019 AJ Radik. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func setInitialViewContoller(_ window:UIWindow) {
        print("SET LOGIN")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if Auth.auth().currentUser != nil {
            
            let uid = Auth.auth().currentUser!.uid
            let docRef = Firestore.firestore().collection("users").document(uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    print("Document EXISTS")
                    Firestore.firestore().collection("users").document(uid).collection("whitelist").getDocuments(completion: { (querySnapshot, error) in
                        print("QuerySnapshot Count: \(querySnapshot!.count)")
                        if querySnapshot!.count > 0 {
                            let window: UIWindow = (UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first)!
                            HomeViewController.loadCardLoader(action: {window.rootViewController = storyboard.instantiateViewController(identifier: "HomeNavigationController") as? UINavigationController})
                        }
                        else {
                            self.showController(controller: storyboard.instantiateViewController(withIdentifier: "InitialNavController"), window: window)
                        }
                    })
                } else {
                    print("Document does not exist")
                    self.showController(controller: storyboard.instantiateViewController(withIdentifier: "InitialNavController"), window: window)
                }
            }
            
        }
        
        else {
            showController(controller: storyboard.instantiateViewController(withIdentifier: "InitialNavController"), window: window)
        }
        
    }

    func showController(controller: UIViewController, window: UIWindow) {
        controller.modalPresentationStyle = .overFullScreen
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        setInitialViewContoller(window!)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

