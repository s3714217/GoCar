//
//  HelpController.swift
//  GoCar
//
//  Created by Thien Nguyen on 23/3/21.
//

import UIKit

class HelpController: UIViewController, UITabBarDelegate{

    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Trip"{
            self.performSegue(withIdentifier: "toTrips", sender: self)
        }
        else if item.title == "Account"{
            self.performSegue(withIdentifier: "toAccount", sender: self)
       
        }
        else if item.title == "Explore"{
            self.performSegue(withIdentifier: "toExplore", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
