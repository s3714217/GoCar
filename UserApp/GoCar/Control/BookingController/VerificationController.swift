//
//  VerificationController.swift
//  GoCar
//
//  Created by Thien Nguyen on 27/3/21.
//

import UIKit
import Firebase
import FirebaseAuth

class VerificationController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var currentUser = User(fullName: "", userID: "")
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet var statusImg: UIImageView!
    @IBOutlet var statusImgDone: UIImageView!
    @IBOutlet weak var area_code: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var emailLbl: UITextField!
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    @IBOutlet var popUp: UIView!
    @IBOutlet weak var errorNoti: UILabel!
    
    var photo: UIImage!
    var photoUploaded = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        statusImg.isHidden = false
        statusImgDone.isHidden = true
        nameLbl.text = currentUser.fullName
        emailLbl.text = Auth.auth().currentUser?.email
        confirmBtn.layer.cornerRadius = 12
       
       
    
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        self.errorNoti.text = ""
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            photoUploaded = -1
            return
        }
        
        if photoUploaded == 0 {
            self.statusImg.isHidden = true
            self.statusImgDone.isHidden = false
            self.photo = image
            photoUploaded = 1
        }
        else{
            errorNoti.text = "No image taken"
        }
       
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func verifying(_ sender: Any) {
        if self.area_code.text!.count != 3 || self.number.text!.count > 11 ||
            self.number.text!.count < 5{
           self.errorNoti.text = "Invalid phone number"
            return
        }
        if !isValidEmail(email: self.emailLbl.text!){
            self.errorNoti.text = "Invalid email"
            return
        }
        if self.photoUploaded < 1 {
            self.errorNoti.text = "Please upload your licence"
            return
        }
        self.currentUser.email = String(self.emailLbl.text!)
        self.currentUser.phone_number = String(self.area_code.text!) + String(self.number.text!)
        self.currentUser.userID = String(Auth.auth().currentUser!.uid)
        DBService().submitVerificationForm(user: self.currentUser, image: self.photo)
        showNotification()
    }
    private func isValidEmail(email: String) -> Bool{
        
        let emailSynx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailSynx)
        return emailPred.evaluate(with: email)
    }
    private func showNotification(){
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
