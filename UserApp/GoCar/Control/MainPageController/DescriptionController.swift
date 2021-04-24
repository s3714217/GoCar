//
//  DescriptionController.swift
//  GoCar
//
//  Created by Thien Nguyen on 12/3/21.
//

import UIKit
import FirebaseFirestore

class DescriptionController: UIViewController {

   
    var selectedCar: Car = Car()
    var carLocation: parking_location = parking_location()
    var distanceFromUser = 0
    var db = Firestore.firestore()
    @IBOutlet weak var carAddress: UILabel!
    @IBOutlet weak var distanceAway: UILabel!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var small_hatch: UILabel!
    @IBOutlet weak var seater: UILabel!
    @IBOutlet weak var child_seat: UILabel!
    @IBOutlet weak var fuel: UILabel!
    @IBOutlet weak var pet: UILabel!
    @IBOutlet weak var apple: UILabel!
    @IBOutlet weak var wheelchair: UILabel!
    @IBOutlet weak var re_camera: UILabel!
    @IBOutlet weak var nav_sys: UILabel!
    @IBOutlet weak var bike: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carImg: UIImageView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBooking"{
            let controller = segue.destination as! BookingController
           
            controller.selectedCar = selectedCar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rateLabel.text = "Rate: $\(selectedCar.rate)/day"
        self.descriptionView.layer.cornerRadius = 12
        self.descriptionView.layer.shadowColor = UIColor.black.cgColor
        self.descriptionView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.descriptionView.layer.shadowRadius = 2.0
        self.descriptionView.layer.shadowOpacity = 0.5
        self.descriptionView.layer.masksToBounds = false
        self.bookBtn.layer.cornerRadius = 12
        self.carAddress.text = selectedCar.parking_location
        self.distanceAway.text = "\(distanceFromUser)m away"
        self.carModel.text = "Model: \(selectedCar.model)"
        self.carType.text = "Type: \(selectedCar.vehicle_type.capitalized)"
        self.carImg.image = UIImage(imageLiteralResourceName: selectedCar.model.lowercased().trimmingCharacters(in: .whitespaces))
        
        self.loading_detail()
    }
    
    @IBAction func toBooking(_ sender: Any) {
        self.performSegue(withIdentifier: "toBooking", sender: self)
    }
    
    @IBAction func backAct(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toDashboard", sender: self)
        
    }
    
    func loading_detail(){
        let docRef = db.collection("car_description").document(selectedCar.model.trimmingCharacters(in: .whitespaces))

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if !(document.get("apple_carplay") as! Bool){
                    self.apple.isHidden = true
                }
                if !(document.get("bike_rack") as! Bool){
                    self.bike.isHidden = true
                }
                if !(document.get("child_seat") as! Bool){
                    self.child_seat.isHidden = true
                }
                if !(document.get("nav_system") as! Bool){
                    self.nav_sys.isHidden = true
                }
                if !(document.get("pet_friendly") as! Bool){
                    self.pet.isHidden = true
                }
                
                self.re_camera.text = (document.get("camera") as? String)?.capitalized
                self.fuel.text = (document.get("petrol") as? String)?.capitalized
                let number = document.get("seat_number") as? Int
                self.seater.text = "\(number ?? 1) Seaters"
                
                
                
            } else {
                print("data does not exist")
            }
        }
        
    }
 
   
    
    
}
