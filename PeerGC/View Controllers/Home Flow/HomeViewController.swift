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
    static var collectionViewStaticReference: UICollectionView?
    static var pageControlStaticReference: UIPageControl?
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var recTutors: UILabel!
    @IBOutlet weak var logOutButton: DesignableButton!
    public static var remoteUserData: [[String: String]] = []
    var timer = Timer()
    static var currentUserImage : UIImage? = nil
    static var currentUserData: [String: String]? = nil
    private static var cardListener: ListenerRegistration?
    private static var reference: CollectionReference?
    private static var action: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = HomeViewController.remoteUserData.count
        recTutors.font = recTutors.font.withSize( (1.3/71) * UIScreen.main.bounds.height)
        firstName.font = firstName.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        welcome.font = welcome.font.withSize( (3.0/71) * UIScreen.main.bounds.height)
        downloadCurrentUserImage()
        let currentUser = Auth.auth().currentUser!
        firstName.text! = currentUser.displayName!.components(separatedBy: " ")[0]
        HomeViewController.collectionViewStaticReference = collectionView
        HomeViewController.pageControlStaticReference = pageControl
        
        if HomeViewController.currentUserData?["accountType"] == DatabaseParser.getDisplayTextFromAnswerID(answerID: "Student") {
            recTutors.text = "YOUR MATCHED MENTORS"
        }
        
        else if HomeViewController.currentUserData?["accountType"] == DatabaseParser.getDisplayTextFromAnswerID(answerID: "Tutor") {
            recTutors.text = "YOUR MATCHED STUDENTS"
        }
        
    }
    
    static func loadCardLoader(action: @escaping () -> Void) {
        HomeViewController.action = action
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid ).getDocument { (document, error) in
            if let document = document, document.exists {
                var dataDescription = document.data()
                
                dataDescription!["uid"] = Auth.auth().currentUser!.uid
                HomeViewController.currentUserData = (dataDescription as! [String : String])

                HomeViewController.reference = Firestore.firestore().collection(["users", Auth.auth().currentUser!.uid, "allowList"].joined(separator: "/"))
                
                self.cardListener = self.reference?.addSnapshotListener { querySnapshot, error in
                  guard let snapshot = querySnapshot else {
                    print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                    return
                  }
                  
                  snapshot.documentChanges.forEach { change in
                    HomeViewController.handleDocumentChange(change)
                  }
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private static func handleDocumentChange(_ change: DocumentChange) {
        
        switch change.type {
            case .added:
                HomeViewController.addChange(change)
            
            case .removed:
                HomeViewController.removeChange(change)
            
            default:
                break
        }
        
    }
    
    static func addChange(_ change: DocumentChange) {
        Firestore.firestore().collection("users").document(change.document.documentID).getDocument { (document, error) in
            if let document = document, document.exists {
                var dataDescription = document.data() as! [String: String]
                dataDescription["uid"] = change.document.documentID
                
                HomeViewController.remoteUserData.append(dataDescription)
                
                HomeViewController.collectionViewStaticReference?.reloadData()
                HomeViewController.pageControlStaticReference?.numberOfPages = HomeViewController.remoteUserData.count

                Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("allowList").getDocuments(completion: { (querySnapshot, error) in
                    DispatchQueue.main.async{
                        print("QuerySnapshot Count: \(querySnapshot!.count)")
                        if querySnapshot!.count == HomeViewController.remoteUserData.count {
                            print("running action")
                            print(action)
                            action()
                            action = {}
                            //GCD here???
                        }
                    }
                })
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    static func removeChange(_ change: DocumentChange) {
        for i in 0..<HomeViewController.remoteUserData.count {
            if HomeViewController.remoteUserData[i]["uid"] == change.document.documentID {
                HomeViewController.remoteUserData.remove(at: i)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        timer.invalidate()
        print("logged out")
        HomeViewController.remoteUserData = []
        transitionToStart()
    }
    
    func transitionToStart() {
        let startViewController = storyboard?.instantiateViewController(identifier: "InitialNavController") as? UINavigationController
        view.window?.rootViewController = startViewController
        view.window?.makeKeyAndVisible()
    }
    
    func downloadCurrentUserImage() {
        let task = URLSession.shared.dataTask(with: Auth.auth().currentUser!.photoURL!) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async { // Make sure you're on the main thread here
                HomeViewController.currentUserImage = UIImage(data: data)!
            }
        }
        task.resume()
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeViewController.remoteUserData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = HomeViewController.remoteUserData[indexPath.item]

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
        return HomeViewController.remoteUserData.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

class CustomCell: UICollectionViewCell {
    
    var data: [String: String]? {
        didSet {
            firstname.font = firstname.font.withSize( (4.0/71) * UIScreen.main.bounds.height)
            cityState.font = cityState.font.withSize( (2.2/71) * UIScreen.main.bounds.height)
            blurb.font = blurb.font.withSize( (1.9/71) * UIScreen.main.bounds.height)
            sentence.font = sentence.font.withSize( (1.6/71) * UIScreen.main.bounds.height)
            button.backgroundColor = UIColor.systemPink

            firstname.text = data!["firstName"]!
            cityState.text = Utilities.getStateByZipCode(zipcode: data!["zipCode"]!)
            
            setSentenceText()
            downloadImage(url: URL(string: data!["photoURL"]!)!, imageView: imageView)
        }
    }
    
    func setSentenceText() {
        if DatabaseParser.getAnswerIDFromDisplayText(displayText: "Student") == data!["accountType"]! {
            
        }
            
        else if DatabaseParser.getAnswerIDFromDisplayText(displayText: "Mentor") == data!["accountType"]! {
            let firstName = data!["firstName"]!
            let schoolYear = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["schoolYear"]!)
            let degree = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["whichDegree"]!)
            let major = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["major"]!)
            let university = "University"
            let testScore = data!["testScore"]!
            let testTaken = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["testTaken"]!)
            let firstGenerationStatus = DatabaseParser.getDisplayTextFromAnswerID(answerID: data!["parentsGoToCollege"]!)
            var firstGenerationString = ""
            
            if firstGenerationStatus == "Yes" {
                firstGenerationString = "isn't"
            }
            
            else {
                firstGenerationString = "is"
            }
            
            let firstLanguge = data!["firstLanguage"]!
            
            let sentenceString = "\(firstName) is a /b\(schoolYear)/b pursuing a /b\(degree)/b degree as a  /b\(major)/b major at /b\(university)/b. \(firstName) applied to college with a /b\(testScore)/b on the /b\(testTaken)/b exam. \(firstName) /b\(firstGenerationString)/b a first generation college student, and their first language is /b\(firstLanguge)/b."
            
            sentence.attributedText = Utilities.blueText(text: sentenceString)
        }
    }
    
    func downloadImage(url: URL, imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async { // Make sure you're on the main thread here
                imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    @IBOutlet weak var button: DesignableButton!
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var blurb: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sentence: UILabel!
    
    @IBAction func messageButtonPressed(_ sender: UIButton) {
        let vc = ChatViewController()
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        if data!["accountType"] == DatabaseParser.getAnswerIDFromDisplayText(displayText: "Student")  {
            vc.id = "\(data!["uid"]!)-\(Auth.auth().currentUser!.uid)"
            print("set ChatVC ID to \(vc.id)")
        }
        
        else if data!["accountType"] == DatabaseParser.getAnswerIDFromDisplayText(displayText: "Mentor") {
            vc.id = "\(Auth.auth().currentUser!.uid)-\(data!["uid"]!)"
            print("set ChatVC ID to \(vc.id)")
        }
        
        vc.header = data!["firstName"]!
        vc.remoteReceiverImage = imageView.image
        vc.currentSenderImage = HomeViewController.currentUserImage
        
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
        if let navigationController = keyWindow?.rootViewController as? UINavigationController {
        //Do something
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func viewProfileButtonPressed(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileVC") as! ProfileVC
        
        vc.customCell = self
        
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
        if let navigationController = keyWindow?.rootViewController as? UINavigationController {
        //Do something
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
