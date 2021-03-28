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
    private var currentUser = User(fullName: "", userID: "")
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    @IBOutlet var popUp: UIView!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var PickUpDatePicker: UIDatePicker!
    
    @IBOutlet weak var ReturnDatePicker: UIDatePicker!
    
    @IBOutlet weak var PlanNo: UIButton!
    @IBOutlet weak var PlanYes: UIButton!
    @IBOutlet weak var PayNo: UIButton!
    @IBOutlet weak var PayYes: UIButton!
    
    @IBOutlet weak var PayPicker: UIDatePicker!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    
    var selectedCar: Car!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVerification"{
            let controller = segue.destination as! VerificationController
            controller.currentUser = self.currentUser
        }
        else if segue.identifier == "toPayment"{
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userID = (Auth.auth().currentUser?.uid)!
        self.closePay()
        self.PlanNo.isHidden = true
        self.PayYes.isHidden = true
        self.PickUpDatePicker.minimumDate = NSDate() as Date
        self.ReturnDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        self.PayPicker.minimumDate = NSDate() as Date
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
        self.lbl5.text = "\(self.lbl5.text!) $\(selectedCar.rate*9)"
        self.lbl4.text = "\(self.lbl4.text!) $\(selectedCar.rate)"
       
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
    
    @IBAction func PlanYesClicked(_ sender: Any) {
        self.PlanNo.isHidden = false
        self.PlanYes.isHidden = true
        self.closePlan()
    }
    
    @IBAction func PlanNoClicked(_ sender: Any) {
        self.PlanNo.isHidden = true
        self.PlanYes.isHidden = false
        self.PayNo.isHidden = false
        self.openPlan()
        self.closePay()
    }
    
    @IBAction func PayNoClicked(_ sender: Any) {
        self.PayYes.isHidden = false
        self.PayNo.isHidden = true
        self.PlanNo.isHidden = false
        self.openPay()
        self.closePlan()
    }
    @IBAction func PayYesClicked(_ sender: Any) {
        self.PayYes.isHidden = true
        self.PayNo.isHidden = false
        self.closePay()
    }
    
    func closePlan(){
        lbl1.isEnabled = false
        lbl2.isEnabled = false
        lbl5.isEnabled = false
        self.PickUpDatePicker.isEnabled = false
        self.ReturnDatePicker.isEnabled = false
    }
    func openPlan(){
        lbl1.isEnabled = true
        lbl2.isEnabled = true
        lbl5.isEnabled = true
        self.PickUpDatePicker.isEnabled = true
        self.ReturnDatePicker.isEnabled = true
        self.PayYes.isHidden = true
    }
    func openPay(){
        lbl3.isEnabled = true
        lbl4.isEnabled = true
        self.PayPicker.isEnabled = true
        
        self.PlanYes.isHidden = true
    }
    func closePay(){
        lbl3.isEnabled = false
        lbl4.isEnabled = false
        self.PayPicker.isEnabled = false
    }
    @IBAction func toPayment(_ sender: Any) {
        self.performSegue(withIdentifier: "toPayment", sender: self)
    }
    
    @IBAction func finishPickUpDate(_ sender: Any) {
        self.ReturnDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: self.PickUpDatePicker.date)
        
    }
    @IBAction func finishReturnDate(_ sender: Any) {
        let numberOfDate = Calendar.current.dateComponents([.day], from: self.PickUpDatePicker.date, to: self.ReturnDatePicker.date)
        let number = numberOfDate.day!
        self.lbl5.text = "Total Cost: $\(self.selectedCar.rate*9*number)"
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

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1 // <1>
    }
}
