//
//  TripController.swift
//  GoCar
//
//  Created by Thien Nguyen on 24/3/21.
//

import UIKit

class TripController: UIViewController, UITabBarDelegate{

    
    @IBOutlet weak var tabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.delegate = self
        // Do any additional setup after loading the view.
    }
    

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Explore"{
           self.performSegue(withIdentifier: "toExplore", sender: self)
        }
        else if item.title == "Account"{
            self.performSegue(withIdentifier: "toAccount", sender: self)
       
        }
        else if item.title == "Help"{
            self.performSegue(withIdentifier: "toHelp", sender: self)
        }
    }
}
