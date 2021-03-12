//
//  EntryController.swift
//  GoCar
//
//  Created by Thien Nguyen on 9/3/21.
//

import UIKit

import Firebase
import FirebaseAuth

class EntryController: UIViewController {

    @IBOutlet weak var joinbtn: UIButton!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.joinbtn.isHidden = true
        self.loginbtn.isHidden = true
        self.spinner.startAnimating()
        let cd = CDService()
        let usr = cd.load()
        
        Auth.auth().signIn(withEmail:usr.email!, password: usr.password!) { authResult, error in
                if error != nil
                {
                    self.spinner.isHidden = true
                    self.joinbtn.isHidden = false
                    self.loginbtn.isHidden = false
                    print ("ERROR",error!)
                   
                }
                else{
                    self.performSegue(withIdentifier: "toDashboard", sender: self)
                }
            }
        
            
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

    
