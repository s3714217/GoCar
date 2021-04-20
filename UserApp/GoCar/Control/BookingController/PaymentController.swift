//
//  PaymentController.swift
//  GoCar
//
//  Created by Thien Nguyen on 29/3/21.
//

import UIKit
import FirebaseAuth
import Braintree

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
    var braintreeClient: BTAPIClient?
    private var saveCard = true
    private let db = DBService()
    
    @IBOutlet weak var notificationLbl: UILabel!
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
   
    
    @IBAction func payclicked(_ sender: Any) {

            braintreeClient = BTAPIClient(authorization: "sandbox_csnw7dwr_ppkg4hc5zs9d3wb5")!
            let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
            var fee = self.selectedCar.rate * self.currentTransaction.numberOfDate
            fee += fee/10
            let request = BTPayPalCheckoutRequest(amount: String(fee))
            request.currencyCode = "AUD" // Optional; see BTPayPalCheckoutRequest.h for more

            payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
                if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                    print("Got a nonce: \(tokenizedPayPalAccount.nonce)")

                    if self.saveCard{
                        DBService().addPayment(user: self.currentUser)
                    }
                    self.PayNowBtn.isEnabled = false
                    DBService().addTransaction(user: self.currentUser, car: self.selectedCar, transaction: self.currentTransaction)

                    self.showPopUp()
                } else if error != nil {
                    print(error)
                    self.notificationLbl.text = "Fail to process payment!"
                    self.notificationLbl.textColor = .red
                } else {
                    self.notificationLbl.text = "Fail to process payment!"
                    self.notificationLbl.textColor = .red
                }
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
    
    
    
 
}
