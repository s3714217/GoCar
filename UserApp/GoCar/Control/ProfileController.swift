//
//  ProfileController.swift
//  GoCar
//
//  Created by Thien Nguyen on 10/3/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ProfileController: UIViewController, UITabBarDelegate {

    private var db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    @IBOutlet weak var tabBar: UITabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
               do {
                 try firebaseAuth.signOut()
       
               } catch let signOutError as NSError {
                 print ("Error signing out: %@", signOutError)
       
            }
        CDService().clear()
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Trips"{
            self.performSegue(withIdentifier: "toTrips", sender: self)
        }
        else if item.title == "Explore"{
            self.performSegue(withIdentifier: "toExplore", sender: self)
       
        }
        else if item.title == "Help"{
            self.performSegue(withIdentifier: "toHelp", sender: self)
        }
    }

}
