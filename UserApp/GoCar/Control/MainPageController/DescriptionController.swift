//
//  DescriptionController.swift
//  GoCar
//
//  Created by Thien Nguyen on 12/3/21.
//

import UIKit

class DescriptionController: UIViewController {

    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carImg: UIImageView!
    var selectedCar: Car = Car()
    var carLocation: parking_location = parking_location()
    var distanceFromUser = 0
    @IBOutlet weak var carAddress: UILabel!
    @IBOutlet weak var distanceAway: UILabel!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBooking"{
            let controller = segue.destination as! BookingController
           
            controller.selectedCar = selectedCar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rateLabel.text = "$\(selectedCar.rate)/hr $\(selectedCar.rate * 9)/day"
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
    }
    
    @IBAction func toBooking(_ sender: Any) {
        self.performSegue(withIdentifier: "toBooking", sender: self)
    }
    
    @IBAction func backAct(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toDashboard", sender: self)
        
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
