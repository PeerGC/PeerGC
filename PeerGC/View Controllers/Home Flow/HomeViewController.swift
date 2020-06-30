//
//  HomeViewController.swift
//  FBex
//
//  Created by AJ Radik on 12/12/19.
//  Copyright © 2019 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var removeButton: DesignableButton!
    @IBOutlet weak var confirmButton: DesignableButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var recTutors: UILabel!
    @IBOutlet weak var logOutButton: DesignableButton!
    public static var customData: [CustomData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = HomeViewController.customData.count
        collectionView.heightAnchor.constraint(equalToConstant:   UIScreen.main.bounds.height * 0.36).isActive = true
        recTutors.font = recTutors.font.withSize( (1.3/71) * UIScreen.main.bounds.height) // max 2.3
        firstName.font = firstName.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        welcome.font = welcome.font.withSize( (3.0/71) * UIScreen.main.bounds.height)
        removeButton.titleLabel?.font = removeButton.titleLabel?.font.withSize( (2.5/71) * UIScreen.main.bounds.height)
        confirmButton.titleLabel?.font = confirmButton.titleLabel?.font.withSize( (2.5/71) * UIScreen.main.bounds.height)
        label.font = label.font.withSize( (1.9/71) * UIScreen.main.bounds.height) // max 2.3
    
        let currentUser = Auth.auth().currentUser!
        firstName.text! = currentUser.displayName!.components(separatedBy: " ")[0]
        
        
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            let currentWhiteList = data["whitelist"] as! NSArray
            
            for uid in currentWhiteList {
                //check if already exists in the showing set
                var doesExist = false
                
                for dataObject in HomeViewController.customData {
                    if dataObject.uid == uid as! String {
                        doesExist = true
                        break
                    }
                }
  
                //if it doesn't exist, then add it
                if !doesExist {
                    Firestore.firestore().collection("users").document(uid as! String).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data()
                            
                            HomeViewController.customData.append(CustomData(firstName:
                                dataDescription!["firstName"] as! String, state: Utilities.getStateByZipCode(zipcode: dataDescription!["zipCode"] as! String)!, city: Utilities.getCityByZipCode(zipcode: dataDescription!["zipCode"] as! String)!, uid: uid as! String, photoURL: URL(string: dataDescription!["photoURL"] as! String)!))
                            
                            self.collectionView.reloadData()
                            self.pageControl.numberOfPages = HomeViewController.customData.count
                            
                           
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
                
            }
            
            for var i in 0..<HomeViewController.customData.count {
                //if the new white list does not contain an old card, remove it
                
                if i >= HomeViewController.customData.count {
                    break
                }
                
                if !currentWhiteList.contains(HomeViewController.customData[i].uid) {
                    HomeViewController.customData.remove(at: i)
                    self.collectionView.deleteItems(at: [IndexPath(item: i, section: 0)])
                    self.collectionView.reloadData()
                    self.pageControl.numberOfPages = HomeViewController.customData.count
                    i-=1
                }
                
            }
        
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        print("logged out")
        HomeViewController.customData = []
        transitionToStart()
    }
    
    @IBAction func removeOrConfirmButtonPressed(_ sender: UIButton) {
        let functions = Functions.functions()
        
        functions.httpsCallable("setCards").call(["uid": Auth.auth().currentUser!.uid]) { (result, error) in
          if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
             
            }
            // ...
          }
          if let text = (result?.data as? [String: Any])?["success"] as? Bool {
            print(text)
          }
        }
        
    }
    
    @IBAction func removeOrConfirmButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 0.7
        }
    }
    
    @IBAction func removeOrConfirmButtonCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 1.0
        }
    }
    
    func transitionToStart() {
        let startViewController = storyboard?.instantiateViewController(identifier: "InitialNavController") as? UINavigationController
        view.window?.rootViewController = startViewController
        view.window?.makeKeyAndVisible()
    }
    
}

class CustomData: Hashable {
    
    static func == (lhs: CustomData, rhs: CustomData) -> Bool {
        return rhs.uid == lhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    var firstName: String
    var state: String
    var city: String
    var uid: String
    var photoURL: URL
    var image: UIImage?
    
    init(firstName: String, state: String, city: String, uid: String, photoURL: URL) {
        self.firstName = firstName
        self.state = state
        self.city = city
        self.uid = uid
        self.photoURL = photoURL
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeViewController.customData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = HomeViewController.customData[indexPath.item]

        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return HomeViewController.customData.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}



class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            //button.backgroundColor = data.color
            firstname.font = firstname.font.withSize( (4.0/71) * UIScreen.main.bounds.height)
            cityState.font = cityState.font.withSize( (2.2/71) * UIScreen.main.bounds.height)
            blurb.font = blurb.font.withSize( (2.0/71) * UIScreen.main.bounds.height)
            button.backgroundColor = UIColor.systemPink
            firstname.text = data.firstName
            cityState.text = data.state.capitalized
            
            if data.image == nil {
                downloadImage()
            }
            
            else {
                imageView.image = data.image
            }
            
        }
    }
    
    func downloadImage() {
        let task = URLSession.shared.dataTask(with: data!.photoURL) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async { // Make sure you're on the main thread here
                self.imageView.image = UIImage(data: data)
                self.data!.image = self.imageView.image
            }
        }
        task.resume()
    }
    
    @IBOutlet weak var button: DesignableButton!
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var blurb: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 0.7
        }
        
    }

    @IBAction func buttonCancel(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 1.0
        }
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        buttonCancel(sender)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
