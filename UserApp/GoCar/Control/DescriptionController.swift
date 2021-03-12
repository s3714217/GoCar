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
    var carName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.carModel.text = carName
        self.carImg.image = UIImage(imageLiteralResourceName: carName)
    }
    

    @IBAction func backAct(_ sender: Any) {
        //selectedItem = "none"
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
