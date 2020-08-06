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

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nothingToSeeHereLabel: UILabel!
    static var collectionViewStaticReference: UICollectionView?
    static var pageControlStaticReference: UIPageControl?
    static var nothingToSeeHereLabelStaticReference: UILabel?
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
        nothingToSeeHereLabel.font = nothingToSeeHereLabel.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
        downloadCurrentUserImage()
        let currentUser = Auth.auth().currentUser!
        firstName.text! = currentUser.displayName!.components(separatedBy: " ")[0]
        HomeViewController.collectionViewStaticReference = collectionView
        HomeViewController.pageControlStaticReference = pageControl
        HomeViewController.nothingToSeeHereLabelStaticReference = nothingToSeeHereLabel
        view.bringSubviewToFront(nothingToSeeHereLabel)
        
        if HomeViewController.remoteUserData.count > 0 {
            nothingToSeeHereLabel.isHidden = true
        }
        
        if HomeViewController.currentUserData?[DatabaseKey.accountType.name] == DatabaseValue.student.name {
            recTutors.text = "YOUR MATCHED MENTORS"
        }
        
        else if HomeViewController.currentUserData?[DatabaseKey.accountType.name] == DatabaseValue.mentor.name {
            recTutors.text = "YOUR MATCHED STUDENTS"
        }
        
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            let alertController = UIAlertController(title: "Please let us send you notifications <3", message: "We'd be really happy if you could allow notifications. This will enable you to receive notifications when your peers message you, or when you're matched with a new peer.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "No :|", style: .default, handler: nil))
            //TODO: /\ \/
            alertController.addAction(UIAlertAction(title: "Yes! :D", style: .default, handler: { action in
                self.setUpNotifications()
            }))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func setUpNotifications() {
        //Messaging
                if #available(iOS 10.0, *) {
                  // For iOS 10 display notification (sent via APNS)
                  UNUserNotificationCenter.current().delegate = self

                  let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                  UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
                } else {
                  let settings: UIUserNotificationSettings =
                  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                }

                UIApplication.shared.registerForRemoteNotifications()
                
                Messaging.messaging().delegate = self
                
                InstanceID.instanceID().instanceID { (result, error) in
                  if let error = error {
                    print("Error fetching remote instance ID: \(error)")
                  } else if let result = result {
                    print("Remote instance ID token: \(result.token)")
                    Firestore.firestore().collection(DatabaseKey.users.name).document(Auth.auth().currentUser!.uid).setData([DatabaseKey.instanceID.name : result.token ], merge: true)
                  }
                }
                //End Messaging
    }
    
    static func loadCardLoader(action: @escaping () -> Void) {
        HomeViewController.action = action
        Firestore.firestore().collection(DatabaseKey.users.name).document(Auth.auth().currentUser!.uid ).getDocument { (document, error) in
            if let document = document, document.exists {
                var dataDescription = document.data()
                
                dataDescription![DatabaseKey.uid.name] = Auth.auth().currentUser!.uid
                HomeViewController.currentUserData = (dataDescription as! [String : String])

                HomeViewController.reference = Firestore.firestore().collection([DatabaseKey.users.name, Auth.auth().currentUser!.uid, DatabaseKey.allowList.name].joined(separator: "/"))
                
                self.cardListener = self.reference?.addSnapshotListener { querySnapshot, error in
                  guard let snapshot = querySnapshot else {
                    print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                    return
                  }
                    
                    print("snapshot count:  \(snapshot.count)")
                    
                    if snapshot.count == 0 {
                        print("running action")
                        print(action)
                        HomeViewController.action()
                        HomeViewController.action = {}
                        nothingToSeeHereLabelStaticReference?.isHidden = false
                    }
                  
                    DispatchQueue.main.async {
                        snapshot.documentChanges.forEach { change in
                          HomeViewController.handleDocumentChange(change)
                        }
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
        print(change.document.documentID)
        
        for data in HomeViewController.remoteUserData {
            if data[DatabaseKey.uid.name] == change.document.documentID {
                print("document already present")
                return
            }
        }
        
        Firestore.firestore().collection(DatabaseKey.users.name).document(change.document.documentID).getDocument { (document, error) in
            if let document = document, document.exists {
                var dataDescription = document.data() as! [String: String]
                dataDescription[DatabaseKey.uid.name] = change.document.documentID
                dataDescription[DatabaseKey.relativeStatus.name] = (change.document.data() as! [String: String])[DatabaseKey.relativeStatus.name]
                HomeViewController.remoteUserData.append(dataDescription)
                
                print(dataDescription)
                
                HomeViewController.collectionViewStaticReference?.reloadData()
                HomeViewController.pageControlStaticReference?.numberOfPages = HomeViewController.remoteUserData.count

                Firestore.firestore().collection(DatabaseKey.users.name).document(Auth.auth().currentUser!.uid).collection(DatabaseKey.allowList.name).getDocuments(completion: { (querySnapshot, error) in
                    DispatchQueue.main.async{
                        print("QuerySnapshot Count: \(querySnapshot!.count)")
                        if querySnapshot!.count == HomeViewController.remoteUserData.count {
                            print("running action")
                            print(action)
                            HomeViewController.action()
                            HomeViewController.action = {}
                            //GCD here???
                            nothingToSeeHereLabelStaticReference?.isHidden = true
                        }
                    }
                })
                
            } else {
                print("Document does not exist. addChange()")
            }
        }
        print("Remote User Data Count: \(HomeViewController.remoteUserData.count)")
    }
    
    static func removeChange(_ change: DocumentChange) {
        
        print("Remote User Data Count: \(HomeViewController.remoteUserData.count)")
        
        for var i in 0..<HomeViewController.remoteUserData.count {
            if HomeViewController.remoteUserData[i][DatabaseKey.uid.name] == change.document.documentID {
                HomeViewController.remoteUserData.remove(at: i)
                i -= 1
                collectionViewStaticReference?.reloadData()
                HomeViewController.pageControlStaticReference?.numberOfPages = HomeViewController.remoteUserData.count
            }
        }
        
        if HomeViewController.remoteUserData.count == 0 {
            nothingToSeeHereLabelStaticReference?.isHidden = false
        }
        
        else {
            nothingToSeeHereLabelStaticReference?.isHidden = true
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
        collectionView.reloadData()
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

extension HomeViewController: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
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
            state.font = state.font.withSize( (2.2/71) * UIScreen.main.bounds.height)
            blurb.font = blurb.font.withSize( (1.9/71) * UIScreen.main.bounds.height)
            sentence.font = sentence.font.withSize( (1.3/71) * UIScreen.main.bounds.height) //TODO: Font too large?
            
            viewProfileButton.titleLabel!.font = viewProfileButton.titleLabel!.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
            messageAddMentorButton.titleLabel!.font = messageAddMentorButton.titleLabel!.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
            
            
            button.backgroundColor = UIColor.systemPink

            firstname.text = data![DatabaseKey.firstName.name]!
            state.text = Utilities.getStateByZipCode(zipcode: data![DatabaseKey.zipCode.name]!)
            
            setSentenceText()
            downloadImage(url: URL(string: data![DatabaseKey.photoURL.name]!)!, imageView: imageView)
            
            setUpMessageAddMentorButton(button: messageAddMentorButton)
        }
    }
    
    func setUpMessageAddMentorButton(button: UIButton) {
        if data![DatabaseKey.accountType.name] == DatabaseValue.mentor.name {
            if data![DatabaseKey.relativeStatus.name] == DatabaseValue.matched.name {
                button.backgroundColor = .systemBlue
                button.setTitle("Message", for: .normal)
            }
            
            else {
                button.backgroundColor = .systemGreen
                button.setTitle("Add Mentor", for: .normal)
            }
        }
    }
    
    func setSentenceText() {
        let firstName = data![DatabaseKey.firstName.name]!
        
        if data![DatabaseKey.accountType.name]! == DatabaseValue.student.name {
            let highSchoolYear = DatabaseValue(name: data![DatabaseKey.schoolYear.name]!)!.rawValue
            let interest = DatabaseValue(name: data![DatabaseKey.interest.name]!)!.rawValue
            
            var whereInProcess = ""
            
            switch DatabaseValue(name: data![DatabaseKey.whereInProcess.name]!) {
                case .hasntStartedLooking:
                    whereInProcess = "has /bnot started/b looking"
                case .startedLookingNoPicks:
                    whereInProcess = "has /bstarted looking/b but hasn't picked any schools"
                case .pickedNotApplying:
                    whereInProcess = "has /bpicked schools/b but hasn't began applying"
                case .startedAppsButStuck:
                    whereInProcess = "has /bstarted applications/b but is stuck"
                case .doneWithApps:
                    whereInProcess = "is /bdone/b with applications"
                default:
                    break
            }
                
            var lookingFor = ""
            
            switch DatabaseValue(name: data![DatabaseKey.lookingFor.name]!) {
                case .keepOnTrack:
                    lookingFor = "to help keep them /bon track/b"
                case .infoOnCollegeWants:
                    lookingFor = "to provide info on what /bcolleges look for/b"
                case .supportSystem:
                    lookingFor = "that can provide a /bsupport system/b in college"
                case .entranceTests:
                    lookingFor = "to help with college /bentrance tests/b"
                case .essays:
                    lookingFor = "to help with /bessays/b"
                default:
                    break
            }
            
            let kindOfCollege = DatabaseValue(name: data![DatabaseKey.feelAboutApplying.name]!) == .dontKnow ? "/bdoesn't know/b what types of colleges they're interested in" : "is interested in /b\(DatabaseValue(name: data![DatabaseKey.kindOfCollege.name]!)!.rawValue)/b"
            
            let sentenceString = "\(firstName) is a /b\(highSchoolYear)/b in high school, and is interested in /b\(interest)/b. ln regards to the college application process, \(firstName) \(whereInProcess). \(firstName) is looking for someone /b\(lookingFor)/b, and \(kindOfCollege)."
            
            sentence.attributedText = Utilities.blueWhiteText(text: sentenceString)
        }
            
        else if data![DatabaseKey.accountType.name]! == DatabaseValue.mentor.name {
            let schoolYear = DatabaseValue(name: data![DatabaseKey.schoolYear.name]!)!.rawValue
            let degree = DatabaseValue(name: data![DatabaseKey.whichDegree.name]!)!.rawValue
            let major = DatabaseValue(name: data![DatabaseKey.major.name]!)!.rawValue
            let university = data![DatabaseKey.collegeName.name]!
            let testScore = data![DatabaseKey.testScore.name]!
            let testTaken = DatabaseValue(name: data![DatabaseKey.testTaken.name]!)!.rawValue
            let highSchoolGPA = DatabaseValue(name: data![DatabaseKey.highSchoolGPA.name]!)!.rawValue
            let firstGenerationStatus = DatabaseValue(name: data![DatabaseKey.parentsGoToCollege.name]!)!
            let firstGenerationString = firstGenerationStatus == .yes ? "isn't" : "is"
            let firstLanguge = data![DatabaseKey.firstLanguage.name]!
            
            let testingString = testTaken == DatabaseValue.otherNone.rawValue ? "applied to college /bwithout/b the SAT or ACT" : "applied to college with a /b\(testScore)/b on the /b\(testTaken)/b exam"
            
            var whyTheyWantToBeCounselor = ""
            
            switch DatabaseValue(name: data![DatabaseKey.whyYouWantBeCounselor.name]!) {
                case .wishSomethingLikeThisExisted:
                    whyTheyWantToBeCounselor = "they wish they knew /bsomething like this/b existed for them"
                case .canHelpWriteStrongEssays:
                    whyTheyWantToBeCounselor = "they can help write /bstrong essays/b"
                case .scoredWellOnAdmissionsTests:
                    whyTheyWantToBeCounselor = "they /bscored well/b on admissions tests"
                case .sociallyEmotionallySupport:
                    whyTheyWantToBeCounselor = "they can /bsocially and emotionally/b support you"
                case .somethingElse:
                    whyTheyWantToBeCounselor = "of an /bUnspecified Reason/b"
                default:
                    break
            }
            
            let sentenceString = "\(firstName) is a /b\(schoolYear)/b pursuing a /b\(degree)/b degree as a(n) /b\(major)/b major at /b\(university)/b. \(firstName) \(testingString), and with a GPA of /b\(highSchoolGPA)/b. \(firstName) /b\(firstGenerationString)/b a first generation college student, and their first language is /b\(firstLanguge)/b. \(firstName) wants to be your counselor because \(whyTheyWantToBeCounselor)."
            
            sentence.attributedText = Utilities.blueWhiteText(text: sentenceString)
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
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var blurb: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sentence: UILabel!
    @IBOutlet weak var messageAddMentorButton: DesignableButton!
    @IBOutlet weak var viewProfileButton: DesignableButton!
    
    @IBAction func addMentorMessageButtonPressed(_ sender: UIButton) {
                
        if sender.titleLabel?.text == "Add Mentor" {
            data![DatabaseKey.relativeStatus.name] = DatabaseValue.matched.name
            Firestore.firestore().collection(DatabaseKey.users.name).document(Auth.auth().currentUser!.uid).collection(DatabaseKey.allowList.name).document(data![DatabaseKey.uid.name]!).setData([DatabaseKey.relativeStatus.name : DatabaseValue.matched.name ], merge: true)
            sender.backgroundColor = .systemBlue
            sender.setTitle("Message", for: .normal)
            let alertController = UIAlertController(title: "Mentor Added!", message: "Congrats, you've added a mentor! Now you can message them, and they can message you.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            let window: UIWindow = (UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first)!
            window.rootViewController!.present(alertController, animated: true, completion: nil)
            return
        }
        
        let vc = ChatViewController()
        
        if HomeViewController.currentUserData?[DatabaseKey.accountType.name] == DatabaseValue.student.name  {
            vc.id = "\(data![DatabaseKey.uid.name]!)-\(Auth.auth().currentUser!.uid)"
            print("set ChatVC ID to \(vc.id)")
        }
        
        else if HomeViewController.currentUserData?[DatabaseKey.accountType.name] == DatabaseValue.mentor.name {
            vc.id = "\(Auth.auth().currentUser!.uid)-\(data![DatabaseKey.uid.name]!)"
            print("set ChatVC ID to \(vc.id)")
        }
        
        vc.header = data![DatabaseKey.firstName.name]!
        vc.customCell = self
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
