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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = data.count
        
       
        collectionView.heightAnchor.constraint(equalToConstant:   UIScreen.main.bounds.height * 0.36).isActive = true // TODO: this can be done on storyboard?
        
        recTutors.font = recTutors.font.withSize( (1.3/71) * UIScreen.main.bounds.height) // max 2.3
        
        firstName.font = firstName.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        welcome.font = welcome.font.withSize( (3.0/71) * UIScreen.main.bounds.height)
        
        removeButton.titleLabel?.font = removeButton.titleLabel?.font.withSize( (2.5/71) * UIScreen.main.bounds.height)
        confirmButton.titleLabel?.font = confirmButton.titleLabel?.font.withSize( (2.5/71) * UIScreen.main.bounds.height)
        //logOutButton.titleLabel?.font = logOutButton.titleLabel?.font.withSize( (1.8/71) * UIScreen.main.bounds.height)
        label.font = label.font.withSize( (1.9/71) * UIScreen.main.bounds.height) // max 2.3
    
        let currentUser = Auth.auth().currentUser!
        firstName.text! = currentUser.displayName!.components(separatedBy: " ")[0]
        
        setCards(amount: 6)
        
    }
    
    func setCards(amount: Int) {
        
        var count = 0
        
        let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)

        docRef.updateData([
            "whitelist" : [],
            "blacklist" : []
        ])
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let accountType = (dataDescription!["accountType"] as! String)
                let zipCode = (dataDescription!["zipCode"] as! String)
                let value = (dataDescription!["value"] as! NSNumber).intValue
                let gender = (dataDescription!["gender"] as! String)
                let interest = (dataDescription!["interest"] as! String)
                let race = (dataDescription!["race"] as! String)
                
                let otherAccountType = accountType == "Tutor" ? "Student" : "Tutor"
               
                let doubleMax = value + 10000
                let doubleMin = value - 10000
                
                
                let usersRef = Firestore.firestore().collection("users")
                
                let query1 = usersRef.whereField("accountType", isEqualTo: otherAccountType).whereField("gender", isEqualTo: gender).whereField("interest", isEqualTo: interest).whereField("race", isEqualTo: race).whereField("value", isLessThan: doubleMax).whereField("value", isGreaterThan: doubleMin).order(by: "value").limit(to: 10)
                
                query1.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            print("query 1")
                            for document in querySnapshot!.documents {
                                
                                if count < amount {
                                    docRef.updateData([
                                        "whitelist": FieldValue.arrayUnion([document.documentID])
                                    ])
                                    count+=1
                                }
            
                                else {
                                    break
                                }
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                            
                            if count < amount {
                                
                                //START Q2
                                let query2 = usersRef.whereField("accountType", isEqualTo: otherAccountType).whereField("interest", isEqualTo: interest).whereField("race", isEqualTo: race).whereField("value", isLessThan: doubleMax).whereField("value", isGreaterThan: doubleMin).order(by: "value").limit(to: 10)

                                query2.getDocuments() { (querySnapshot, err) in
                                        if let err = err {
                                            print("Error getting documents: \(err)")
                                        } else {
                                            print("query 2")
                                            for document in querySnapshot!.documents {
                                                
                                                if count < amount {
                                                    docRef.updateData([
                                                        "whitelist": FieldValue.arrayUnion([document.documentID])
                                                    ])
                                                    count+=1
                                                }
                            
                                                else {
                                                    break
                                                }
                                                
                                                print("\(document.documentID) => \(document.data())")
                                            }
                                            
                                            if count < amount {
                                            //START Q3
                                                let query3 = usersRef.whereField("accountType", isEqualTo: otherAccountType).whereField("interest", isEqualTo: interest).whereField("value", isLessThan: doubleMax).whereField("value", isGreaterThan: doubleMin).order(by: "value").limit(to: 10)

                                                query3.getDocuments() { (querySnapshot, err) in
                                                        if let err = err {
                                                            print("Error getting documents: \(err)")
                                                        } else {
                                                            print("query 3")
                                                            for document in querySnapshot!.documents {
                                                                
                                                                if count < amount {
                                                                    docRef.updateData([
                                                                        "whitelist": FieldValue.arrayUnion([document.documentID])
                                                                    ])
                                                                    count+=1
                                                                }
                                            
                                                                else {
                                                                    break
                                                                }
                                                                
                                                                print("\(document.documentID) => \(document.data())")
                                                            }
                                                            
                                                            if count < amount {
                                                            //START Q4
                                                                let query4 = usersRef.whereField("accountType", isEqualTo: otherAccountType).whereField("value", isLessThan: doubleMax).whereField("value", isGreaterThan: doubleMin).order(by: "value").limit(to: 10)

                                                                query4.getDocuments() { (querySnapshot, err) in
                                                                        if let err = err {
                                                                            print("Error getting documents: \(err)")
                                                                        } else {
                                                                            print("query 4")
                                                                            for document in querySnapshot!.documents {
                                                                                
                                                                                if count < amount {
                                                                                    docRef.updateData([
                                                                                        "whitelist": FieldValue.arrayUnion([document.documentID])
                                                                                    ])
                                                                                    count+=1
                                                                                }
                                                            
                                                                                else {
                                                                                    break
                                                                                }
                                                                                
                                                                                print("\(document.documentID) => \(document.data())")
                                                                            }
                                                                            
                                                                            if count < amount {
                                                                            //START Q5
                                                                                let query5 = usersRef.whereField("accountType", isEqualTo: otherAccountType).limit(to: 10)

                                                                                query5.getDocuments() { (querySnapshot, err) in
                                                                                        if let err = err {
                                                                                            print("Error getting documents: \(err)")
                                                                                        } else {
                                                                                            print("query 5")
                                                                                            for document in querySnapshot!.documents {
                                                                                                
                                                                                                if count < amount {
                                                                                                    docRef.updateData([
                                                                                                        "whitelist": FieldValue.arrayUnion([document.documentID])
                                                                                                    ])
                                                                                                    count+=1
                                                                                                }
                                                                                                
                                                                                                else {
                                                                                                    break
                                                                                                }
                                                                                                
                                                                                                print("\(document.documentID) => \(document.data())")
                                                                                            }
                                                                                        }
                                                                                }
                                                                            //END Q5
                                                                            }
                                                                            
                                                                        }
                                                                }
                                                            //END Q4
                                                            }
                                                            
                                                        }
                                                }
                                            //END Q3
                                            }
                                            
                                        }
                                }
                                //END Q2
                                
                                
                            }
                            
                        }
                }
                
                print("got here")
                
                
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    fileprivate let data = [
        CustomData(color: UIColor.systemPink),
        CustomData(color: UIColor.systemRed),
        CustomData(color: UIColor.systemPink),
        CustomData(color: UIColor.systemGreen),
        CustomData(color: UIColor.systemPink)
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        print("logged out")
        transitionToStart()
    }
    
    @IBAction func removeOrConfirmButtonPressed(_ sender: UIButton) {
        removeOrConfirmButtonCancel(sender)
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

struct CustomData {
    var color: UIColor
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = self.data[indexPath.item]

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
        return data.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}



class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            button.backgroundColor = data.color
            firstname.font = firstname.font.withSize( (4.0/71) * UIScreen.main.bounds.height)
            cityState.font = cityState.font.withSize( (3.0/71) * UIScreen.main.bounds.height)
            blurb.font = blurb.font.withSize( (2.3/71) * UIScreen.main.bounds.height)
        }
    }
    
    @IBOutlet weak var button: DesignableButton!
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var blurb: UILabel!
    
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
