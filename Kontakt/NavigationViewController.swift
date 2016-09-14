//
//  NavigationViewController.swift
//  Kontakt
//
//  Created by Diego Salazar on 9/14/16.
//  Copyright © 2016 Diego Salazar. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.barTintColor = UIColor(red: (91.0/255.0)-0.12, green: (202.0/255.0)-0.12, blue: (255.0/255.0)-0.12, alpha: 1.0)
        self.navigationBar.tintColor = UIColor.whiteColor()
    }

}
