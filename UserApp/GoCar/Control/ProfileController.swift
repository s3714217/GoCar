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

class ProfileController: UIViewController {

    private var db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

}
