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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var recTutors: UILabel!
    @IBOutlet weak var logOutButton: DesignableButton!
    public static var customData: [CustomData] = []
    var timer = Timer()
    static var currentUserImage : UIImage? = nil
    static var currentUserCustomData: CustomData? = nil
    private var cardListener: ListenerRegistration?
    private var reference: CollectionReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = HomeViewController.customData.count
        collectionView.heightAnchor.constraint(equalToConstant:   UIScreen.main.bounds.height * 0.36).isActive = true
        recTutors.font = recTutors.font.withSize( (1.3/71) * UIScreen.main.bounds.height) // max 2.3
        firstName.font = firstName.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        welcome.font = welcome.font.withSize( (3.0/71) * UIScreen.main.bounds.height)
        label.font = label.font.withSize( (1.9/71) * UIScreen.main.bounds.height) // max 2.3
        downloadCurrentUserImage()
        let currentUser = Auth.auth().currentUser!
        firstName.text! = currentUser.displayName!.components(separatedBy: " ")[0]
        
        
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid ).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                
                HomeViewController.currentUserCustomData = CustomData(firstName:
                    dataDescription!["firstName"] as! String, state: Utilities.getStateByZipCode(zipcode: dataDescription!["zipCode"] as! String)!, city: Utilities.getCityByZipCode(zipcode: dataDescription!["zipCode"] as! String)!, uid: Auth.auth().currentUser!.uid , photoURL: URL(string: dataDescription!["photoURL"] as! String)!, accountType: dataDescription!["accountType"] as! String, interest: dataDescription!["interest"] as! String, gender: dataDescription!["gender"] as! String, race: dataDescription!["race"] as! String)

                
            } else {
                print("Document does not exist")
            }
        }
        
        reference = Firestore.firestore().collection(["users", Auth.auth().currentUser!.uid, "whitelist"].joined(separator: "/"))
        
        
        cardListener = reference?.addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
          
          snapshot.documentChanges.forEach { change in
            self.handleDocumentChange(change)
          }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        
        switch change.type {
            case .added:
                addChange(change)
            
            case .removed:
                removeChange(change)
            
            default:
                break
        }
        
    }
    
    func addChange(_ change: DocumentChange) {
        Firestore.firestore().collection("users").document(change.document.documentID).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                
                HomeViewController.customData.append(CustomData(firstName:
                    dataDescription!["firstName"] as! String, state: Utilities.getStateByZipCode(zipcode: dataDescription!["zipCode"] as! String)!, city: Utilities.getCityByZipCode(zipcode: dataDescription!["zipCode"] as! String)!, uid: change.document.documentID, photoURL: URL(string: dataDescription!["photoURL"] as! String)!, accountType: dataDescription!["accountType"] as! String, interest: dataDescription!["interest"] as! String, gender: dataDescription!["gender"] as! String, race: dataDescription!["race"] as! String))

                self.collectionView.reloadData()
                self.pageControl.numberOfPages = HomeViewController.customData.count

            } else {
                print("Document does not exist")
            }
        }
    }
    
    func removeChange(_ change: DocumentChange) {
        for i in 0..<HomeViewController.customData.count {
            if HomeViewController.customData[i].uid == change.document.documentID {
                HomeViewController.customData.remove(at: i)
            }
        }
    }
    
    var tempCounter = 0
    var processing: [String] = []
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        timer.invalidate()
        print("logged out")
        HomeViewController.customData = []
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
    var accountType: String
    var interest: String
    var gender: String
    var race: String
    
    init(firstName: String, state: String, city: String, uid: String, photoURL: URL, accountType: String, interest: String, gender: String, race: String) {
        self.firstName = firstName
        self.state = state
        self.city = city
        self.uid = uid
        self.photoURL = photoURL
        self.accountType = accountType
        self.interest = interest
        self.gender = gender
        self.race = race
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
            blurb.font = blurb.font.withSize( (1.9/71) * UIScreen.main.bounds.height)
            sentence.font = sentence.font.withSize( (1.6/71) * UIScreen.main.bounds.height)
            button.backgroundColor = UIColor.systemPink
            firstname.text = data.firstName
            cityState.text = data.state.capitalized
            race = data.race
            gender = data.gender
            interest = data.interest
            
            setSentenceText()
            
            if data.image == nil {
                downloadImage()
            }
            
            else {
                imageView.image = data.image
            }
            
        }
    }
    
    var race = ""
    var gender = ""
    var interest = ""
    
    func setSentenceText() {
        
        let sentence: NSMutableAttributedString = NSMutableAttributedString()
        
        var temp = NSMutableAttributedString(string: "You and ")
        temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: temp.length))
        sentence.append(temp)
        
        temp = NSMutableAttributedString(string: "\(firstname.text!) ")
        temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: temp.length))
        sentence.append(temp)
        
        temp = NSMutableAttributedString(string: "are both")
        temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: temp.length))
        sentence.append(temp)
        
        let raceEqual = HomeViewController.currentUserCustomData?.race == race
        let genderEqual = HomeViewController.currentUserCustomData?.gender == gender
        let interestEqual = HomeViewController.currentUserCustomData?.interest == interest
        
        let comma = NSMutableAttributedString(string: ",")
        comma.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: comma.length))
        
        if raceEqual {
            temp = NSMutableAttributedString(string: " \(race)")
            temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSRange(location:0, length: temp.length))
            sentence.append(temp)
            sentence.append(comma)
        }
        
        if genderEqual {
            temp = NSMutableAttributedString(string: " \(gender)")
            temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSRange(location:0, length: temp.length))
            sentence.append(temp)
            sentence.append(comma)
        }
        
        if interestEqual {
            temp = NSMutableAttributedString(string: " interested in")
            temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: temp.length))
            sentence.append(temp)
            
            temp = NSMutableAttributedString(string: " \(interest)")
            temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSRange(location:0, length: temp.length))
            sentence.append(temp)
            sentence.append(comma)
        }
        
        if raceEqual || genderEqual || interestEqual {
            temp = NSMutableAttributedString(string: " and")
            temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: temp.length))
            sentence.append(temp)
        }
        
        temp = NSMutableAttributedString(string: " likely to come from")
        temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: temp.length))
        sentence.append(temp)
        
        temp = NSMutableAttributedString(string: " similar financial backgrounds")
        temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSRange(location:0, length: temp.length))
        sentence.append(temp)
        
        temp = NSMutableAttributedString(string: "!")
        temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0, length: temp.length))
        sentence.append(temp)
        
        self.sentence.attributedText = sentence
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
    @IBOutlet weak var sentence: UILabel!
    
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        
        
    }

    @IBAction func buttonCancel(_ sender: UIButton) {
        
       
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let vc = ChatViewController()
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        if data!.accountType == "Student" {
            vc.id = "\(data!.uid)-\(Auth.auth().currentUser!.uid)"
        }
        
        else if data!.accountType == "Tutor" {
            vc.id = "\(Auth.auth().currentUser!.uid)-\(data!.uid)"
        }
        
        vc.header = data!.firstName
        vc.remoteReceiverImage = data!.image
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
