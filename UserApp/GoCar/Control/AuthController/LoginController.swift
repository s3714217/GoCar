//
//  LoginController.swift
//  GoCar
//
//  Created by Thien Nguyen on 8/3/21.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController , UITextFieldDelegate{

    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var notification: UILabel!
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
        self.email.delegate = self
        self.password.delegate = self
        self.password.textContentType = .password
        self.password.isSecureTextEntry = true
        self.email.textContentType = .emailAddress
        self.logIn.layer.cornerRadius = 12
    }
    
    @IBAction func login(_ sender: Any) {
        
        self.logIn.isEnabled = false
        if email.text!.count < 1 || password.text!.count < 1{
            self.displayNoti(noti: "* Email and password cannot be empty")
            self.logIn.isEnabled = true
            
            return
        }
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        Auth.auth().signIn(withEmail:self.email.text!, password: self.password.text!) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
                let e = error!.localizedDescription
                if e == "The email address is badly formatted."{
                    self.displayNoti(noti: "* Invalid email")
                    self.logIn.isEnabled = true
                    self.spinner.stopAnimating()
                }
                else if e == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    self.displayNoti(noti: "* User doesn't exist")
                    self.logIn.isEnabled = true
                    self.spinner.stopAnimating()
                }
                else if e == "The password is invalid or the user does not have a password."{
                    self.displayNoti(noti: "* Wrong password")
                    self.logIn.isEnabled = true
                    self.spinner.stopAnimating()
                }
                else if e == "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."{
                    self.displayNoti(noti: "* Too many failed attempts. Try again later")
                    self.logIn.isEnabled = true
                    self.spinner.stopAnimating()
                }
            }
            else{
                
                CDService().addUser(email: self.email.text!, password: self.password.text!)
                self.spinner.stopAnimating()
                self.performSegue(withIdentifier: "toDashboard", sender: self)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func displayNoti(noti: String){
        
        self.notification.textColor = .red
        self.notification.font = UIFont(name: "Arial", size: 13)
        self.notification.text! = noti
    }
    
}
