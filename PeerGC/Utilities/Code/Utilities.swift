//
//  Utilities.swift
//  FBex
//
//  Created by AJ Radik on 1/2/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Utilities {
    
    static func getBuildConfiguration() -> String {
        #if DEBUG
            return "DEV"
        #else
            return "PROD"
        #endif
    }
    
    static func logError(customMessage: String = "General Error", customCode: Int = 0, fileName: String = #file, functionName: String = #function, lineNumber: Int = #line, columnNumber: Int = #column) {
        
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString(customMessage, comment: ""),
            "Version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            "Build": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown",
            "File Name": fileName,
            "Function Name": functionName,
            "Line Number": String(lineNumber),
            "Column Number": String(columnNumber),
            "UID": Auth.auth().currentUser?.uid ?? "Not Availible."
        ]
        
        let error = NSError.init(domain: "org.PeerGC.PeerGC.ErrorDomain", code: customCode, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
        print("ERROR:")
        print(error.userInfo)
    }
    
    static func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String: Any] = ["to": token,
                                           "notification": ["title": title, "body": body],
                                           "data": ["user": "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("""
            key=AAAAcwvPqgU:APA91bHuy-lLYO2EYgE-\
            CPPRNBOcfs4bE09ovTWoRdHwj1OYNFYE8DL0\
            15xD0R5tDF09uiv4Lx3O3cUVEzrQTCq9MrcV\
            jKsPRyHROoJ-M4060uTU9d0urYslX5HoqmkK\
            U_4aJ7OFvbnw
            """, forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
    static func loadHomeScreen() {
        let window: UIWindow = (UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first)!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navVC = storyboard.instantiateViewController(identifier: "HomeNavigationController") as? UINavigationController else { return }
        guard let homeVC = navVC.viewControllers.first as? HomeViewController else { return }
                
        homeVC.loadView()
        homeVC.awakeFromNib()
        
        homeVC.loadCardLoader {
            navVC.modalPresentationStyle = .overFullScreen
            window.rootViewController = navVC
            window.makeKeyAndVisible()
        }
    }
    
    static func coloredText(text: String, specialColor: UIColor, regularColor: UIColor) -> NSMutableAttributedString {
        let components = text.components(separatedBy: "/b")
        let toReturn = NSMutableAttributedString(string: "")
        
        var makeBlue = false
        
        for component in components {
            if makeBlue {
                let temp = NSMutableAttributedString(string: component)
                temp.addAttribute(NSAttributedString.Key.foregroundColor, value: specialColor, range: NSRange(location: 0, length: temp.length))
                toReturn.append(temp)
            } else {
                let temp = NSMutableAttributedString(string: component)
                temp.addAttribute(NSAttributedString.Key.foregroundColor, value: regularColor, range: NSRange(location: 0, length: temp.length))
                toReturn.append(temp)
            }
            
            makeBlue = !makeBlue
        }
        
        return toReturn
    }
    
    static func indigoWhiteText(text: String) -> NSMutableAttributedString {
        return coloredText(text: text, specialColor: .systemIndigo, regularColor: .white)
    }
    
    static func indigoLabelText(text: String) -> NSMutableAttributedString {
        return coloredText(text: text, specialColor: .systemIndigo, regularColor: .label)
    }
    
    static func getSimilarZipCodes(zipcode: String) -> [String] {
        let zipCodeValue = Double(getValueByZipCode(zipcode: zipcode)!)
        let path: String? = Bundle.main.path(forResource: "zipCodesToValue", ofType: "csv")
        let dataString = getDataString(path: path)!
        let data = csv(data: dataString)
        
        var zipCodesWrapped: [ZipCodeWrapper] = []
        
        for row in data {
            zipCodesWrapped.append(ZipCodeWrapper(zipcode: row[0], difference: Double(row[1])!-zipCodeValue!))
        }
        
        zipCodesWrapped.sort()
        
        var toReturn: [String] = []
        
        for wrappedZipCode in zipCodesWrapped {
            toReturn.append(wrappedZipCode.zipcode)
        }
        
        return toReturn
    }

    class ZipCodeWrapper: Comparable {

        let zipcode: String
        let difference: Double
        
        init(zipcode: String, difference: Double) {
            self.zipcode = zipcode
            self.difference = abs(difference)
        }
        
        static func < (lhs: Utilities.ZipCodeWrapper, rhs: Utilities.ZipCodeWrapper) -> Bool {
            return lhs.difference < rhs.difference
        }

        static func == (lhs: Utilities.ZipCodeWrapper, rhs: Utilities.ZipCodeWrapper) -> Bool {
            return lhs.difference == rhs.difference
        }

    }
    
    static func zipCodeDoesExist(zipcode: String) -> Bool {
        let path: String? = Bundle.main.path(forResource: "zipCodes", ofType: "txt")
        let dataString = getDataString(path: path)!
        let data = csv(data: dataString)
        
        for row in data {
            if row[0] == zipcode {
                return true
            }
        }
        
        return false
    }
    
    static func getValueByZipCode(zipcode: String) -> String? {
        let path: String? = Bundle.main.path(forResource: "zipCodesToValue", ofType: "csv")
        let dataString = getDataString(path: path)!
        let data = csv(data: dataString)
        
        for row in data {
            if row[0] == zipcode {
                return row[1]
            }
        }
        return nil
    }
    
    static func getCityByZipCode(zipcode: String) -> String? {
        let path: String? = Bundle.main.path(forResource: "zipCodesToLocation", ofType: "csv")
        let dataString = getDataString(path: path)!
        let data = csv(data: dataString)
        
        for row in data {
            if row[0] == zipcode {
                return row[1]
            }
        }
        return nil
    }
    
    static func getStateByZipCode(zipcode: String) -> String? {
         let path: String? = Bundle.main.path(forResource: "zipCodesToLocation", ofType: "csv")
               let dataString = getDataString(path: path)!
               let data = csv(data: dataString)
               
               for row in data {
                   if row[0] == zipcode {
                    return row[2].trimmingCharacters(in: ["\r"])
                   }
               }
               return nil
    }
    
    static func getDataString(path: String?) -> String? {
        do {
            let dataString = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            return dataString
        } catch let error {
            print(error)
        }
        return nil
    }
    
    static func csv(data: String) -> [[String]] {
           let dataTrimmed = data.trimmingCharacters(in: .whitespacesAndNewlines)
           var result: [[String]] = []
           let rows = dataTrimmed.components(separatedBy: "\n")
           for row in rows {
               let columns = row.components(separatedBy: ", ")
               result.append(columns)
           }
           return result
       }
    
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
