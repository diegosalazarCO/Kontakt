//
//  Contact.swift
//  Kontakt
//
//  Created by Diego Salazar on 8/29/16.
//  Copyright © 2016 Diego Salazar. All rights reserved.
//

import UIKit
import CoreLocation

let url = NSBundle.mainBundle().URLForResource("data", withExtension: "json")
let data = NSData(contentsOfURL: url!)

struct Contact {
    let name: String
    var photo: UIImage?
    let phone: String
    let homePhone: String
    let mobilePhone: String?
    let company: String
    let location: CLLocationCoordinate2D
    //let detailsURL: NSURL
    var isFavorite: Bool = false
    //let latitude: Double
    //let longitude: Double
}

extension Contact {
    init?(dict: [String : AnyObject]) {
        guard let name = dict["name"] as? String,
            let phone = dict["phone"]!["work"] as? String,
            let homePhone = dict["phone"]!["home"] as? String?,
            //let mobilePhone = dict["phone"]?["mobile"] as? String?,
            let company = dict["company"] as? String,
            let contactURL = dict["detailsURL"] as? String else {
                return nil
        }

        //self.detailsURL = NSBundle.mainBundle().URLForResource(contactURL, withExtension: "json")!
        //self.detailsURL = detailsURL
        //let detailsData = NSData(contentsOfURL: detailsURL)
        
        self.name = name
        self.phone = phone
        self.homePhone = homePhone!
        self.mobilePhone = "345353"
        self.company = company
        // TODO: Change hardcoded value
        self.location = CLLocationCoordinate2D(latitude: 34.060897, longitude: -117.932632)
        
//        do {
//            let object = try NSJSONSerialization.JSONObjectWithData(detailsData!, options: .AllowFragments)
//            if let dictionary = object as? [String: AnyObject] {
//                guard let isFavorite = dictionary["favorite"] as? Bool else {
//                    return nil
//                }
//                self.isFavorite = isFavorite
//            }
//        } catch let error as NSError {
//            print("Failed to load: \(error.localizedDescription)")
//        }
//        
//        print(self.isFavorite)
        
        let photoURL = NSURL(string: (dict["smallImageURL"] as? String)!)
        
        func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
            NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                completion(data: data, response: response, error: error)
                }.resume()
        }
        
        func downloadImage(url: NSURL){
            print("Download Started")
            print("lastPathComponent: " + (url.lastPathComponent ?? ""))
            getDataFromUrl(url) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    print(response?.suggestedFilename ?? "")
                    print("Download Finished")
                    self.photo = UIImage(data: data)
                }
            }
        }
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            let data = NSData(contentsOfURL: photoURL!)
//            dispatch_async(dispatch_get_main_queue(), {
//                self.photo = UIImage(data: data!)
//                print(self.photo?.accessibilityIdentifier)
//            });
//        }
//        if let imageName = dict["smallImageURL"] as? String where !imageName.isEmpty {
//            photo = UIImage(named: imageName)
//        } else {
//            photo = nil
//        }
    }
}

extension Contact {
    static func getContacts() -> [Contact]? {
        let postEndpoint: String = "https://solstice.applauncher.com/external/contacts.json"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        var contacts = [Contact]?()
        while contacts == nil {
        // Make the GET call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Parse JSON and create contacts with the data
            do {
                let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let dictionary = object as? [[String: AnyObject]] {
//                    dispatch_async(dispatch_get_main_queue(), {
                        print("\(dictionary.count) ---  Cuenta dictionary")
                        contacts = dictionary.map { Contact(dict: $0)! }
                            .filter { $0 != nil }
                            .map { $0 }
                        print(contacts)
//                    })
                    print("\(contacts) ---  Contactos")
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }).resume()
//        print(contacts)
        }
        return contacts
    }
}
