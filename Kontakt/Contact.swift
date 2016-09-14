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
    var email: String
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
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: contactURL)!
        
        func getContactDetails(completionHandler: [String: AnyObject] -> ()){
            // Make the GET call and handle it in a completion handler
            session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                guard let realResponse = response as? NSHTTPURLResponse where
                    realResponse.statusCode == 200 else {
                        print("Not a 200 response")
                        return
                }
                
                // Parse JSON and create contacts with the data
                do {
                    var contact = [String: AnyObject]?()
                    let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if let dictionary = object as? [String: AnyObject] {
//                        guard let isFavorite = dictionary["favorite"] else {
//                            return
//                        }
                        completionHandler(dictionary)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }).resume()
        }
        
        
        self.name = name
        self.phone = phone
        self.homePhone = homePhone!
        self.mobilePhone = "345353"
        self.company = company
        // TODO: Change hardcoded value
        self.location = CLLocationCoordinate2D(latitude: 34.060897, longitude: -117.932632)
        
        var contactDetails = [String: AnyObject]()
        getContactDetails({
            contact in
            contactDetails = contact
//            guard let isFavorite = contact["favorite"] as? Bool,
//                let email = contact["email"] as? String else {
//                    return
//            }
//            print(email)
//            //self.isFavorite = isFavorite
//            self.email = email
            print(contactDetails)
        })
        
        //self.email = (contactDetails["email"] as? String)!
        self.email = ""
        // Downloading Photos
        
        let photoURL = NSURL(string: (dict["smallImageURL"] as? String)!)
        
        func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
            NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                completion(data: data, response: response, error: error)
                }.resume()
        }
        
        func downloadImage(url: NSURL, completionHandler: (photo: UIImage) -> ()){
            print("Download Started")
            print("lastPathComponent: " + (url.lastPathComponent ?? ""))
            getDataFromUrl(url) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    print(response?.suggestedFilename ?? "")
                    print("Download Finished")
                    completionHandler(photo: UIImage(data: data)!)
                }
            }
        }
        
        downloadImage(photoURL!, completionHandler: {
            photo in
            print(photo)
            self.photo = photo
        })
    }
}

extension Contact {
    static func getContacts(completionHandler: (contacts: [Contact]) -> ()) {
        let postEndpoint: String = "https://solstice.applauncher.com/external/contacts.json"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the GET call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Parse JSON and create contacts with the data
            do {
                var contacts = [Contact]?()
                let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let dictionary = object as? [[String: AnyObject]] {
                    //dispatch_async(dispatch_get_main_queue(), {
                        contacts = dictionary.map { Contact(dict: $0)! }
                            .filter { $0 != nil }
                            .map { $0 }
                        completionHandler(contacts: contacts!)
                    //}) 
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }).resume()
    }
}
