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
    
    
    var detailItem: Contact? {
        didSet {
            // Update the view.
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
            //photo.image = contact.photo ?? UIImage(named: "image2_large.jpeg")
            companyLabel?.text = contact.company
            
        }
        
        let favoriteButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = favoriteButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        centreMap(locationView, atPosition: CLLocationCoordinate2D(latitude: 34.060897, longitude: 117.932632))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func insertNewObject(sender: AnyObject) {
        // TODO: If we want to insert new objects
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

