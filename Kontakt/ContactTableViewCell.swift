//
//  ContactTableViewCell.swift
//  Kontakt
//
//  Created by Diego Salazar on 8/30/16.
//  Copyright © 2016 Diego Salazar. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var photoThumb: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainPhoneLabel: UILabel!
    
    var contact: Contact? {
        didSet {
            if let contact = contact {
                nameLabel?.text = contact.name
                mainPhoneLabel?.text = contact.phone
                if let profileImageURL = contact.photo {
                    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                        let imageData = NSData(contentsOfURL: profileImageURL)
                        dispatch_async(dispatch_get_main_queue()) {
                            if profileImageURL == contact.photo {
                                if imageData != nil {
                                    self.photoThumb?.image = UIImage(data: imageData!)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
