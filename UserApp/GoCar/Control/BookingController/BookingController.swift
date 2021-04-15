//
//  BookingController.swift
//  GoCar
//
//  Created by Thien Nguyen on 27/3/21.
//

import UIKit
import Firebase
import FirebaseAuth

class BookingController: UIViewController{

    private var userID = ""
    private let databaseService = DBService()
    var currentUser = User()
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    @IBOutlet var popUp: UIView!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var PickUpDatePicker: UIDatePicker!
    
    @IBOutlet weak var ReturnDatePicker: UIDatePicker!
   
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
   
    @IBOutlet weak var lbl5: UILabel!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var lbl6: UILabel!
    var selectedCar: Car!
    var numberOfDate = 1
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVerification"{
            let controller = segue.destination as! VerificationController
            controller.currentUser = self.currentUser
        }
        else if segue.identifier == "toPayment"{
            let controller = segue.destination as! PaymentController
            controller.currentUser = self.currentUser
            controller.selectedCar = self.selectedCar
            var trans = Transaction()
            trans.startDate = self.PickUpDatePicker.date
            trans.returnDate = self.ReturnDatePicker.date
            trans.numberOfDate = numberOfDate
            controller.currentTransaction = trans
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userID = (Auth.auth().currentUser?.uid)!
        self.currentUser.userID = userID
        self.continueBtn.layer.cornerRadius = 12
        self.PickUpDatePicker.minimumDate = NSDate() as Date
        self.ReturnDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
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
         self.lbl6.text = self.selectedCar.parking_location
          self.lbl5.text = "\(self.lbl5.text!) $\(selectedCar.rate)"
         
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
    
    @IBAction func toPayment(_ sender: Any) {
        
        if currentUser.renting{
            showNotification()
            self.verifyBtn.isHidden = true
            self.notification.text = "Return your car before booking"
        }
        else{
            self.performSegue(withIdentifier: "toPayment", sender: self)
        }
        
        
    }
    
    @IBAction func finishPickUpDate(_ sender: Any) {
        self.ReturnDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: self.PickUpDatePicker.date)
        
    }
    @IBAction func finishReturnDate(_ sender: Any) {
        let numberOfDate = Calendar.current.dateComponents([.day], from: self.PickUpDatePicker.date, to: self.ReturnDatePicker.date)
        let number = numberOfDate.day!
        self.numberOfDate = number
        self.lbl5.text = "Total Cost: $\(self.selectedCar.rate*number)"
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




