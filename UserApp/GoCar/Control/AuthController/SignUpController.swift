//
//  SignUpController.swift
//  GoCar
//
//  Created by Thien Nguyen on 8/3/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var fullName: UITextField!
    
    @IBOutlet private weak var email: UITextField!
    
    @IBOutlet private weak var password: UITextField!
    
    @IBOutlet private weak var confirmPassword: UITextField!
    
    @IBOutlet private weak var notification: UILabel!
    
    @IBOutlet weak var verificationCode: UITextField!
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private var code = 0
    let db = DBService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.acceptBtn.layer.cornerRadius = 12
        self.spinner.isHidden = true
        self.password.textContentType = .password
        self.password.isSecureTextEntry = true
        self.fullName.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.confirmPassword.delegate = self
        self.verificationCode.delegate = self
        self.confirmPassword.textContentType = .password
        self.confirmPassword.isSecureTextEntry = true
        self.email.textContentType = .emailAddress
        self.fullName.textContentType = .name
        
    }
    
    @IBAction func SignUp(_ sender: Any) {
        self.acceptBtn.isHidden = true
       
        if self.code == 0{
            self.displayNoti(noti: "* Please verified your email before continue")
            self.acceptBtn.isHidden = false
            return
        }
        
        if verificationCode.text! != String(self.code){
            self.displayNoti(noti: "* Verification Code is incorrect")
            self.acceptBtn.isHidden = false
            return
        }
        
        if self.fullName.text!.count < 1
            || self.email.text!.count < 1
            || self.password.text!.count < 1
            || self.verificationCode.text!.count < 1
        {
            self.displayNoti(noti: "* Please fill out all fields before continue")
            self.acceptBtn.isHidden = false
            return
        }
        
        if !self.isValidEmail(email: self.email.text!){
            self.displayNoti(noti: "* Invalid email address")
            self.acceptBtn.isHidden = false
            return
        }
        
        if self.password.text! != self.confirmPassword.text! {
            self.displayNoti(noti: "* Confirm password does not match")
            self.acceptBtn.isHidden = false
            return
        }
        
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { authResult, error in
            if error != nil{
                self.displayNoti(noti: "* Email already in use")
                self.acceptBtn.isHidden = false
            }
            else{
                self.spinner.isHidden = false
                self.spinner.startAnimating()
                Auth.auth().signIn(withEmail:self.email.text!, password: self.password.text!) { authResult, error in
                    if error != nil {
                        self.displayNoti(noti: "* Error with user authentication")
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true
                        self.acceptBtn.isHidden = false
                    }
                    else{
                        
                        self.db.addUserInfo(userID: Auth.auth().currentUser!.uid, fullName: self.fullName.text!, email: self.email.text!)
                        CDService().addUser(email: self.email.text!, password: self.password.text!)
                        self.spinner.stopAnimating()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    @IBOutlet weak var verifyBtn: UIButton!
    
    @IBAction func verifiyClicked(_ sender: Any) {
       
        
        
        if self.isValidEmail(email: self.email.text!){
            self.notification.textColor = .systemGreen
            self.notification.font = UIFont(name: "Arial", size: 13)
            self.notification.text! = "* The Verification Code has been sent to your email!"
            self.verifyBtn.setTitle("Retry", for: .normal)
            self.code = generateCode()
            print(code)
            self.db.sendVerificationCode(email: self.email.text!, code: String(self.code))
        }
        else{
            self.displayNoti(noti: "* Invalid email address")
        }
    }
    
    func generateCode() -> Int{
       var place = 1
       var finalNumber = 0;
        for _ in 1...5{
            place *= 10
            let randomNumber = arc4random_uniform(10)
            finalNumber += Int(randomNumber) * place
      }
      return finalNumber
    }
    

}
