//
//  DetailViewController.swift
//  Kontakt
//
//  Created by Diego Salazar on 8/29/16.
//  Copyright © 2016 Diego Salazar. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var mobilePhoneLabel: UILabel!
    @IBOutlet weak var homePhoneLabel: UILabel!
    @IBOutlet weak var workPhoneLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var locationView: MKMapView!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityAddressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    var isFavorite: Bool = false
    var detailItem: Contact? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let contact = self.detailItem {
            nameLabel?.text = contact.name
            workPhoneLabel?.text = contact.phone
            homePhoneLabel?.text = contact.homePhone
            mobilePhoneLabel?.text = contact.mobilePhone
            companyLabel?.text = contact.company
            isFavorite = contact.isFavorite
            birthdayLabel?.text = contact.birthday
            
            // Make request and download details from contacts
            if let url = contact.detailsURL {
                    self.getContactDetails(url)
                }
            }
        
        let favoriteButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(changeFavoriteState(_:)))
        self.navigationItem.rightBarButtonItem = favoriteButton
        favoriteButton.tintColor = UIColor.grayColor()
    }
    
    private func getContactDetails(contactURL: String) -> Void {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: contactURL)!
        
        func getContactDetails(){
            session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                guard let realResponse = response as? NSHTTPURLResponse where
                    realResponse.statusCode == 200 else {
                        print("Not a 200 response")
                        return
                }
                
                // Parse JSON and update UI with new data
                do {
                    let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if let dictionary = object as? [String: AnyObject] {
                        let imageURL = NSURL(string: (dictionary["largeImageURL"] as? String)!)
                        let imageData = NSData(contentsOfURL: imageURL!)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.emailLabel.text = dictionary["email"] as? String
                            self.streetAddressLabel.text = dictionary["address"]!["street"] as? String
                            self.cityAddressLabel.text = dictionary["address"]!["city"] as? String
                            let latitude = dictionary["address"]!["latitude"] as? Double
                            let longitude = dictionary["address"]!["longitude"] as? Double
                            self.centreMap(self.locationView, atPosition: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
                            if imageData != nil {
                                self.photo.image = UIImage(data: imageData!)
                            }
                            self.isFavorite = (dictionary["favorite"] as? Bool)!
                            if self.isFavorite {
                                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
                            }
                        })
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }).resume()
        }
        getContactDetails()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func changeFavoriteState(sender: AnyObject) {
        if self.isFavorite {
            self.isFavorite = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.grayColor()
        } else {
            self.isFavorite = true
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        }
    }

    private func centreMap(map: MKMapView?, atPosition position: CLLocationCoordinate2D?) {
        guard let map = map,
            let position = position else {
                return
        }
        map.zoomEnabled = true
        map.scrollEnabled = true
        map.pitchEnabled = false
        map.rotateEnabled = false
        
        map.setCenterCoordinate(position, animated: true)
        
        let zoomRegion = MKCoordinateRegionMakeWithDistance(position, 1000000, 1000000)
        map.setRegion(zoomRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = position
        map.addAnnotation(annotation)
        
    }

}

