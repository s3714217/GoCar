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

class ProfileController: UIViewController, UITabBarDelegate , UITextFieldDelegate{

    private var databaseService = DBService()
    private let user = Auth.auth().currentUser
    var db = Firestore.firestore()
    @IBOutlet weak var signoutBtn: UIButton!
    @IBOutlet weak var contactPane: UIView!
    @IBOutlet weak var detailPanel: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var verified: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var popNotification: UILabel!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var changeBtn: UIButton!
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    var current_user : User!
    var edit = false
    @IBOutlet weak var detail: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHistory"{
            let controller = segue.destination as! HistoryController
           
            controller.history = self.current_user.history
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signoutBtn.layer.cornerRadius = 12
        self.contactPane.layer.cornerRadius = 12
        self.contactPane.layer.shadowColor = UIColor.black.cgColor
        self.contactPane.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.contactPane.layer.shadowRadius = 2.0
        self.contactPane.layer.shadowOpacity = 0.5
        self.contactPane.layer.masksToBounds = false
        self.detailPanel.layer.cornerRadius = 12
        self.detailPanel.layer.shadowColor = UIColor.black.cgColor
        self.detailPanel.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.detailPanel.layer.shadowRadius = 2.0
        self.detailPanel.layer.shadowOpacity = 0.5
        self.detailPanel.layer.masksToBounds = false
        self.signoutBtn.layer.shadowColor = UIColor.black.cgColor
        self.signoutBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.signoutBtn.layer.shadowRadius = 2.0
        self.signoutBtn.layer.shadowOpacity = 0.5
        self.signoutBtn.layer.masksToBounds = false
    
        self.tabBar.delegate = self
        self.email.delegate = self
        self.phone.delegate = self
        self.oldPassword.delegate = self
        self.newPassword.delegate = self
        
        self.databaseService.retrieveUserInformation(userID: Auth.auth().currentUser!.uid)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ timer in
            if self.databaseService.getUser().fullName.count > 1{
                timer.invalidate()
                super.viewDidLoad()
                self.current_user = self.databaseService.getUser()
                self.setUp()
                self.detail.isEnabled = true
            }
           
        }
        
        
    }
    
    @IBAction func edit(_ sender: Any) {
        if !edit{
            self.editBtn.setTitle("Done", for: .normal)
            edit = true
            self.email.isEnabled = true
            self.phone.isEnabled = true
            self.email.borderStyle = .roundedRect
            self.phone.borderStyle = .roundedRect
        }
        else{
            
            if isValidEmail(email: self.email.text!){
                if self.phone.text!.count > 9 && self.phone.text!.count < 13{
                    self.editBtn.setTitle("Edit", for: .normal)
                    edit = false
                    self.email.isEnabled = false
                    self.phone.isEnabled = false
                    self.email.borderStyle = .none
                    self.phone.borderStyle = .none
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                        "phoneNumber" : self.phone.text!,
                        "contactEmail" : self.email.text!
                    ])
                    self.notification.isHidden = true
                }
                else{
                    self.notification.isHidden = false
                    self.notification.text! = "Invalid phone number"
                }
            }
            else{
                self.notification.isHidden = false
                self.notification.text! = "Invalid email"
            }
            
            
            
            
        }
    }
    
    
    @IBOutlet weak var bookingCount: UILabel!
    
    func setUp(){
        
        self.fullname.text! = self.current_user.fullName
        self.bookingCount.text! = "\(String(self.current_user.history.count)) completed trips"
        self.email.text! = self.current_user.email
        self.phone.text! = self.current_user.phone_number
        if self.current_user.verified == "pending"{
            self.verified.text! = self.current_user.verified.uppercased()
            self.verified.textColor = .systemYellow
        }
        else if self.current_user.verified == "unverified"{
            self.verified.text! = self.current_user.verified.uppercased()
            self.verified.textColor = .systemRed
        }
        
        self.email.isEnabled = false
        self.phone.isEnabled = false
        
    }
    
    
    
    
    
    
    
    
   
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Trip"{
            self.performSegue(withIdentifier: "toTrips", sender: self)
        }
        else if item.title == "Explore"{
            self.performSegue(withIdentifier: "toExplore", sender: self)
       
        }
        else if item.title == "Help"{
            self.performSegue(withIdentifier: "toHelp", sender: self)
        }
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
    
    private func isValidEmail(email: String) -> Bool{
        
        let emailSynx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailSynx)
        return emailPred.evaluate(with: email)
    }

    @IBAction func change(_ sender: Any) {
        blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .clear
        self.view.addSubview(blurEffectView)
        self.view.addSubview(self.popUpView)
        self.popUpView.isHidden = false
        self.popUpView.center = self.view.center
        self.popUpView.layer.cornerRadius = 30
        self.changeBtn.layer.cornerRadius = 12
        self.popNotification.isHidden = true
    }
    @IBAction func changeConfirm(_ sender: Any) {
        
        if self.oldPassword.text! ==  CDService().load().password {
            if self.newPassword.text!.count > 4 {
                Auth.auth().currentUser?.updatePassword(to: self.newPassword.text!) { (error) in
                }

                self.popNotification.isHidden = false
                self.popNotification.text! = "Password successfully changed"
                self.popNotification.textColor = .systemGreen

            }
            else{
                self.popNotification.isHidden = false
                self.popNotification.text! = "New password is too short"

            }
        }
        else{
            self.popNotification.isHidden = false
            self.popNotification.text! = "Old password is incorrect"
        }
       
    }
    @IBAction func cancel(_ sender: Any) {
        self.blurEffectView.removeFromSuperview()
        self.popUpView.removeFromSuperview()
    }
}
