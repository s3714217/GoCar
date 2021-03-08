//
//  SignUpController.swift
//  GoCar
//
//  Created by Thien Nguyen on 8/3/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpController: UIViewController {

    @IBOutlet private weak var fullName: UITextField!
    
    @IBOutlet private weak var email: UITextField!
    
    @IBOutlet private weak var password: UITextField!
    
    @IBOutlet private weak var confirmPassword: UITextField!
    
    @IBOutlet private weak var notification: UILabel!
    
    let db = DBService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.password.textContentType = .password
        self.password.isSecureTextEntry = true
        
        self.confirmPassword.textContentType = .password
        self.confirmPassword.isSecureTextEntry = true
        
        self.email.textContentType = .emailAddress
        
        self.fullName.textContentType = .name
        
    }
    
    @IBAction func SignUp(_ sender: Any) {
        
        if self.fullName.text!.count < 1
            || self.email.text!.count < 1
            || self.password.text!.count < 1
        {
            self.displayNoti(noti: "* Please fill out all fields before continue")
            return
        }
        
        if !self.isValidEmail(email: self.email.text!){
            self.displayNoti(noti: "* Invalid email address")
            return
        }
        
        if self.password.text! != self.confirmPassword.text! {
            self.displayNoti(noti: "* Confirm password does not match")
            return
        }
        
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { authResult, error in
            if error != nil{
                self.displayNoti(noti: "* Email already in use")
            }
            else{
                Auth.auth().signIn(withEmail:self.email.text!, password: self.password.text!) { authResult, error in
                    if error != nil {
                        self.displayNoti(noti: "* Error with user authentication")
                    }
                    else{
                        self.db.addUserInfo(userID: Auth.auth().currentUser!.uid, fullName: self.fullName.text! )
                        self.performSegue(withIdentifier: "toDashboard", sender: self)
                    }
                }
            }
        }
       
    }
    
    private func displayNoti(noti: String){
        
        self.notification.textColor = .red
        self.notification.font = UIFont(name: "Arial", size: 13)
        self.notification.text! = noti
    }
    
    private func isValidEmail(email: String) -> Bool{
        
        let emailSynx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailSynx)
        return emailPred.evaluate(with: email)
    }
    
    
    

}
