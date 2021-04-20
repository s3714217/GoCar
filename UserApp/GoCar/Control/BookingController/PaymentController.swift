//
//  PaymentController.swift
//  GoCar
//
//  Created by Thien Nguyen on 29/3/21.
//

import UIKit
import FirebaseAuth
import CreditCardValidator

class PaymentController: UIViewController {

    @IBOutlet weak var PayNowBtn: UIButton!
    @IBOutlet weak var sumView: UIView!
    @IBOutlet weak var carModelLbl: UILabel!
    @IBOutlet weak var totalBeforeTax: UILabel!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var returnLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var payFeeLbl: UILabel!
    @IBOutlet var popUp: UIView!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expDateTF: UITextField!
    @IBOutlet weak var expYearTF: UITextField!
    @IBOutlet weak var cvvTF: UITextField!
    
    private var saveCard = true
    private let db = DBService()
    
    var selectedCar: Car!
    var currentUser: User!
    var currentTransaction: Transaction!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toBooking"{
            let controller = segue.destination as! BookingController
            controller.selectedCar = self.selectedCar
            controller.currentUser = self.currentUser
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.currentUser.email)
        setUp()
        sumView.layer.shadowColor = UIColor.black.cgColor
        sumView.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        sumView.layer.shadowRadius = 2.0
        sumView.layer.shadowOpacity = 0.5
        sumView.layer.masksToBounds = false
        sumView.layer.cornerRadius = 12
        self.PayNowBtn.layer.cornerRadius = 12
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.performSegue(withIdentifier: "toBooking", sender: self)
    }
    
    func setUp(){
        
        self.customerName.text = self.currentUser.fullName
        self.cardNumber.text = self.currentUser.card.cardNumber
        
        self.cvvTF.text = self.currentUser.card.cvv
        
        var tempmonth = ""
        var tempyear = ""
        
        for s in self.currentUser.card.date{
            if s != "/"{
                if tempmonth.count < 2{
                    tempmonth.append(s)
                }
                else if tempyear.count < 2{
                    tempyear.append(s)
                }
            }
           
        }
        self.expDateTF.text = tempmonth
        self.expYearTF.text = tempyear
        
        if  self.currentUser.card.cardNumber.count > 1 {
            self.noBtn.isHidden = true
            self.yesBtn.isHidden = false
        }
        else{
            self.noBtn.isHidden = false
            self.yesBtn.isHidden = true
            
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        carModelLbl.text = self.selectedCar.model
        totalBeforeTax.text = "$\(self.selectedCar.rate * self.currentTransaction.numberOfDate)"
        startLbl.text = "Start Date: \(dateFormatter.string(from: self.currentTransaction.startDate))"
        returnLbl.text = "Return Date: \(dateFormatter.string(from: self.currentTransaction.returnDate)) "
        rateLbl.text = "Rate: $\(self.selectedCar.rate)/day x \(self.currentTransaction.numberOfDate) day"
        subtotalLbl.text = totalBeforeTax.text
        let total = self.selectedCar.rate * self.currentTransaction.numberOfDate
        taxLbl.text = "$\(total/10)"
        payFeeLbl.text = "$\(total/10 + total)"
    }
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
   
    @IBAction func yesClicked(_ sender: Any) {
        yesBtn.isHidden = true
        noBtn.isHidden = false
        self.saveCard = false
    }
    
    @IBAction func noClicked(_ sender: Any) {
        noBtn.isHidden = true
        yesBtn.isHidden = false
        self.saveCard = true
        
    }
    
    @IBAction func payclicked(_ sender: Any) {
        
        
        
        if isValidCard(){
            let card = cardNumber.text!
            let cvv = cvvTF.text!
            var date = self.expDateTF.text!
            date += "/"
            date += self.expYearTF.text!
            self.currentUser.card.cardNumber = card
            self.currentUser.card.cvv = cvv
            self.currentUser.card.date = date
            currentUser.userID = (Auth.auth().currentUser?.uid)!
            
            if DBService().processPayment(card: self.currentUser.card, amount: self.currentTransaction.amount)
            {
                if self.saveCard{
                    DBService().addPayment(user: self.currentUser)
                }
                self.PayNowBtn.isEnabled = false
                DBService().addTransaction(user: currentUser, car: selectedCar, transaction: currentTransaction)
                
                showPopUp()
            }
            else{
                self.notificationLbl.text = "Fail to process payment!"
                self.notificationLbl.textColor = .red
            }
            
           
        }
        else{
            self.notificationLbl.text = "Invalid Credit Card!"
            self.notificationLbl.textColor = .red
        }
        
    }
    
    
    @IBOutlet weak var popCarModel: UILabel!
    @IBOutlet weak var popRego: UILabel!
    @IBOutlet weak var returnDate: UILabel!
    @IBOutlet weak var popParking: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    private func showPopUp(){
        
        db.sendEmailConfirmation(user: self.currentUser, trans: self.currentTransaction, selectedCar: selectedCar)
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
        popCarModel.text = selectedCar.model
        popRego.text = selectedCar.rego
        popParking.text = selectedCar.parking_location
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        doneBtn.layer.cornerRadius = 12
        returnDate.text = dateFormatter.string(from: self.currentTransaction.returnDate)
    }
    
    private func isValidCard() -> Bool{
        
        if CreditCardValidator().validate(string: cardNumber.text!){
            let cvvSynx = "^[0-9]{3}$"
            let cvvPred = NSPredicate(format:"SELF MATCHES %@", cvvSynx)
            if cvvPred.evaluate(with: self.cvvTF.text!){
                let dateSynx = "^[0-9]{2}$"
                let datePred = NSPredicate(format:"SELF MATCHES %@", dateSynx)
                if datePred.evaluate(with: self.expDateTF.text!) && datePred.evaluate(with: self.expYearTF.text!){
                    return true
                }
                else{
                    return false
                }
                
            }
            else{
                return false
            }
        }
        else{
           return false
        }
      
    }
    
 
}
