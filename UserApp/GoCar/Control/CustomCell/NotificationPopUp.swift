//
//  NotificationPopUp.swift
//  GoCar
//
//  Created by Thien Nguyen on 20/4/21.
//

import UIKit

class NotificationPopUp: UIViewController {

    var from = ""
    var content = ""
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet var popUpView: UIView!
    
    private var blurEffect : UIBlurEffect = .init()
    private var blurEffectView : UIVisualEffectView = .init()
    
    override func viewDidLoad() {
        
        blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .clear
        
        self.view.addSubview(self.blurEffectView)
        self.view.addSubview(self.popUpView)
        
        self.popUpView.center = self.view.center
        self.popUpView.layer.cornerRadius = 30
        
        self.contentLbl.text = self.content
        
        super.viewDidLoad()
    }
    
    @IBAction func Done(_ sender: Any) {
        self.performSegue(withIdentifier: self.from, sender: self)
    }
    
}
