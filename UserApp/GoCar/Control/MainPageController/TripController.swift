//
//  TripController.swift
//  GoCar
//
//  Created by Thien Nguyen on 24/3/21.
//

import UIKit

import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import MapKit

class TripController: UIViewController, UITabBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    
    
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var no_trip: UIStackView!
    @IBOutlet weak var CompleteBtn: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    
    var current_transaction = Transaction()
    var current_car = Car()
    var db = Firestore.firestore()
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var status: UIStackView!
    @IBOutlet weak var status_text: UILabel!
    @IBOutlet weak var general_stack: UIStackView!
    private var overdue_cost = 0
    private var databaseService = DBService()
    override func viewDidLoad() {
        
       
        self.returnBtn.layer.cornerRadius = 12
        self.CompleteBtn.layer.cornerRadius = 12
        self.tabBar.delegate = self
        databaseService.retrieveUserInformation(userID: Auth.auth().currentUser!.uid)
        databaseService.retreivingAllCars()
        databaseService.retrieveTransaction(userID: Auth.auth().currentUser!.uid)
        var count = 5
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            
            if count == 0{
                timer.invalidate()
            }
            
            if self.databaseService.getTransaction().carID.count > 3 && self.databaseService.getCars().count > 3{
                timer.invalidate()
                self.current_transaction = self.databaseService.getTransaction()
                let cars = self.databaseService.getCars()
               
                for c in cars{
                    if c.rego == self.current_transaction.carID{
                        self.current_car = c
                        break
                    }
                  
                }
                self.no_trip.isHidden = true
                self.setup()
                
                super.viewDidLoad()
                
            }
            count -= 1
           
        }
        
    }
    

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Explore"{
           self.performSegue(withIdentifier: "toExplore", sender: self)
        }
        else if item.title == "Account"{
            self.performSegue(withIdentifier: "toAccount", sender: self)
       
        }
        else if item.title == "Help"{
            self.performSegue(withIdentifier: "toHelp", sender: self)
        }
    }
    
    func setup(){
        //print("setup")
        self.image.image = UIImage(imageLiteralResourceName: self.current_car.model.lowercased().trimmingCharacters(in: .whitespaces))
        self.model.text = self.current_car.model
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        self.date.text = "\(dateFormatter.string(from: self.current_transaction.startDate)) - \(dateFormatter.string(from: self.current_transaction.returnDate))"
        
        self.address.text = self.current_car.parking_location
        self.total.text = "$\(String(self.current_transaction.amount))"
        self.general_stack.isHidden = false
        self.status.isHidden = false
        self.processing_time()
        
        if self.current_transaction.return_address != "none"{
            self.address_stack.isHidden = false
            self.address.text = self.current_transaction.return_address
            self.returningDisplay()
        }
        
        
    }
    @IBOutlet weak var due_time: UIStackView!
    @IBOutlet weak var address_stack: UIStackView!
    @IBOutlet weak var due_date: UILabel!
    @IBOutlet weak var total_lbl: UILabel!
    func processing_time(){
        
        let numberOfhour = Calendar.current.dateComponents([.hour], from: Date(), to: self.current_transaction.startDate)
        if numberOfhour.hour! <= 0{
            status_text.text = "Current Trip"
            self.returnBtn.isHidden = false
            due_time.isHidden = false
            address_stack.isHidden = true
            
            let date_left = Calendar.current.dateComponents([.day], from: Date(), to: self.current_transaction.returnDate)
            let hour_left =  Calendar.current.dateComponents([.hour], from: Date(), to: self.current_transaction.returnDate)
            let second_left = Calendar.current.dateComponents([.second], from: Date(), to: self.current_transaction.returnDate)
            
            if second_left.second! > 0{
                if hour_left.hour! >= 0 && hour_left.hour! < 24{
                    due_date.text = "Car due in \(hour_left.hour!) hours"
                }
                
                else if date_left.day! == 1 {
                    due_date.text = "Car due in 1 day"
                }
                else{
                    due_date.text = "Car due in \(date_left.day!) days"
                }
            }
            else{
                self.due_date.text = "Car Overdue!"
                let date_overdue = Calendar.current.dateComponents([.day], from: self.current_transaction.returnDate, to: Date())
                if date_overdue.day! > 0 {
                    self.overdue_cost = self.current_car.rate * date_overdue.day!
                    self.total.text = "$\(String( self.current_car.rate * date_overdue.day!))"
                    self.total_lbl.text = "Overdue Cost: "
                    
                }
                
                
            }
            
        }
        
    }
    
   
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    private var pickerData : [String] = []
    private var all_location: [parking_location] = []
    private var nearest = false
    private var nearest_location : parking_location!
    private var selected_address = ""
    @IBOutlet weak var noCustom: UIButton!
    @IBOutlet weak var yesCustom: UIButton!
    @IBOutlet weak var noNear: UIButton!
    @IBOutlet weak var yesNear: UIButton!
    
    @IBOutlet weak var nearest_address: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var photoStack: UIStackView!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var photoStatus: UIImageView!
    @IBAction func returnAction(_ sender: Any) {
        self.returnBtn.isEnabled = false
        databaseService.retrievingLocation()
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            if self.databaseService.getLocation().count > 1{
                timer.invalidate()
                self.all_location = self.databaseService.getLocation()
                 self.popUp()
                    
            }
          
        }
    }
    
    @IBOutlet var payPop: UIView!
    func payPopUp(){
        blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .clear
        self.view.addSubview(blurEffectView)
        self.view.addSubview(self.payPop)
        self.payPop.isHidden = false
        self.payPop.center = self.view.center
        self.payPop.layer.cornerRadius = 30
       
    }
    
    func popUp(){
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
        self.confirmBtn.layer.cornerRadius = 12
       
        for p in self.all_location{
            pickerData.append(p.address)
         
        }
        self.nearest_address.text = self.current_car.parking_location
       
        self.pickerView.delegate = self
        
    }
    
    
    
    @IBAction func confirmAction(_ sender: Any) {
        self.popUpView.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        self.returningDisplay()
        if nearest{
            self.selected_address = self.current_car.parking_location
        }
        self.address_stack.isHidden = false
        self.address.text = self.selected_address
        self.db.collection("transaction").document(self.current_transaction.id).updateData(["return_address" : self.selected_address])
    
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.popUpView.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        self.returnBtn.isEnabled = true
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 11)
            label.text =  pickerData[row].capitalized
            label.textAlignment = .center
            return label
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected_address = pickerData[row]
    }
    
    @IBAction func noNearClicked(_ sender: Any) {
       selectNear()
        
    }
    
    @IBAction func yesNearClicked(_ sender: Any) {
       selectCustom()
    }
    @IBAction func noCustom(_ sender: Any) {
        selectCustom()
    }
    @IBAction func yesCustom(_ sender: Any) {
     
        selectNear()
    }
    
    func selectNear(){
        self.nearest = true
        noCustom.isHidden = false
        yesCustom.isHidden = true
        yesNear.isHidden = false
        noNear.isHidden = true
        self.nearest_address.textColor = .black
    
    }
    func selectCustom(){
        self.nearest = false
        self.nearest_address.textColor = .lightGray
        noCustom.isHidden = true
        yesCustom.isHidden = false
        yesNear.isHidden = true
        noNear.isHidden = false
    }
    func returningDisplay(){
        self.returnBtn.isHidden = true
        self.CompleteBtn.isHidden = false
        self.status_text.text = "Returning"
        self.due_time.isHidden = true
        self.photoStack.isHidden = false
        
    }
    
    var photo: UIImage!
    var photoUploaded = 0
    let imagePicker = UIImagePickerController()
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            photoUploaded = -1
            return
        }
        
        if photoUploaded == 0 {
            self.photo = image
            photoUploaded = 1
        }
        
        if photoUploaded == 1{
            
            if self.overdue_cost > 0{
                self.payPopUp()
            }
            else{
                databaseService.finishReturning(userID: Auth.auth().currentUser!.uid, transaction: self.current_transaction, car: self.current_car, address: self.selected_address,image: self.photo)
                self.performSegue(withIdentifier: "toExplore", sender: self)
                databaseService.sendFinishTrip(user: databaseService.getUser(), trans: self.current_transaction, overdueCost: self.overdue_cost)
            }
               
           
        }
        
    }
    
    @IBAction func complete_trip(_ sender: Any) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
    }
    
    @IBAction func cancelPay(_ sender: Any) {
        self.popUpView.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        
    }
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var notification: UILabel!
    @IBAction func payNow(_ sender: Any) {
        
        if databaseService.processPayment(card: databaseService.getUser().card, amount: self.current_transaction.amount){
            databaseService.finishReturning(userID: Auth.auth().currentUser!.uid, transaction: self.current_transaction, car: self.current_car, address: self.selected_address,image: self.photo)
            self.performSegue(withIdentifier: "toExplore", sender: self)
            databaseService.sendFinishTrip(user: databaseService.getUser(), trans: self.current_transaction, overdueCost: self.overdue_cost)
        }
        else{
            notification.text! = "Failed to process payment"
            notification.textColor = .red
            payBtn.setTitle("Retry", for: .normal)
        }
       
    }
    
}
