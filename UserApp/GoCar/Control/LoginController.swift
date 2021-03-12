//
//  LoginController.swift
//  GoCar
//
//  Created by Thien Nguyen on 8/3/21.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {

    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var notification: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.password.textContentType = .password
        self.password.isSecureTextEntry = true
        
        self.email.textContentType = .emailAddress
        
    }
    
    @IBAction func login(_ sender: Any) {
        if email.text!.count < 1 || password.text!.count < 1{
            self.displayNoti(noti: "* Email and password cannot be empty")
            return
        }
        Auth.auth().signIn(withEmail:self.email.text!, password: self.password.text!) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
                let e = error!.localizedDescription
                if e == "The email address is badly formatted."{
                    self.displayNoti(noti: "* @yahInvalid email")
                }
                else if e == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    self.displayNoti(noti: "* User doesn't exist")
                }
                else if e == "The password is invalid or the user does not have a password."{
                    self.displayNoti(noti: "* Wrong password")
                }
                else if e == "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."{
                    self.displayNoti(noti: "* Too many failed attempts. Try again later")
                }
            }
            else{
                self.performSegue(withIdentifier: "toDashboard", sender: self)
            }
        }
    }
    
    private func displayNoti(noti: String){
        
        self.notification.textColor = .red
        self.notification.font = UIFont(name: "Arial", size: 13)
        self.notification.text! = noti
    }
    
}
