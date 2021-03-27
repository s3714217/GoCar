//
//  BookingController.swift
//  GoCar
//
//  Created by Thien Nguyen on 27/3/21.
//

import UIKit
import Firebase
import FirebaseAuth

class BookingController: UIViewController {

    private var userID = ""
    private let databaseService = DBService()
    private var currentUser = User(fullName: "", userID: "")
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    @IBOutlet var popUp: UIView!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVerification"{
            let controller = segue.destination as! VerificationController
            controller.currentUser = self.currentUser
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userID = (Auth.auth().currentUser?.uid)!
       
        databaseService.retrieveUserInformation(userID: userID)
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ timer in
            if self.databaseService.getUser().fullName.count > 1{
                timer.invalidate()
                self.currentUser = self.databaseService.getUser()
                if self.currentUser.verified == "unverified"{
                    self.showNotification()
                    self.notification.text = "Please verify before booking"
                }
                else if self.currentUser.verified == "pending"{
                    self.showNotification()
                    self.notification.text = "Your verification form is pending"
                    self.verifyBtn.setTitle("Re-Submit", for: .normal)
                }
                super.viewDidLoad()
                
            }
           
        }
        
       
    }
    
    func showNotification(){
        blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .clear
        self.view.addSubview(blurEffectView)
        self.view.addSubview(self.popUp)
        self.popUp.isHidden = false
        self.popUp.center = self.view.center
        self.popUp.layer.cornerRadius = 30
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
