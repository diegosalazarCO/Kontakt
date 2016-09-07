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
                photoThumb.image = contact.photo
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
