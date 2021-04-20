//
//  HelpController.swift
//  GoCar
//
//  Created by Thien Nguyen on 23/3/21.
//

import UIKit

class HelpController: UIViewController, UITabBarDelegate{
 
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    let call_number = "1300 000 000"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self
       
        
        titleView.layer.cornerRadius = 12
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleView.layer.shadowRadius = 2.0
        titleView.layer.shadowOpacity = 0.5
        titleView.layer.masksToBounds = false
        
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Trip"{
            self.performSegue(withIdentifier: "toTrips", sender: self)
        }
        else if item.title == "Account"{
            self.performSegue(withIdentifier: "toAccount", sender: self)
       
        }
        else if item.title == "Explore"{
            self.performSegue(withIdentifier: "toExplore", sender: self)
        }
    }

    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var back: UIButton!
    @IBAction func backBtn(_ sender: Any) {
        self.titleView.isHidden = false
        self.questionView.isHidden = true
        self.til.text = "Help"
        self.back.isHidden = true
    }
    @IBOutlet weak var til: UILabel!
    
    @IBAction func calling(_ sender: Any) {
        guard let number = URL(string: "tel://" + "1300000000") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    @IBAction func emailing(_ sender: Any) {
        let appURL = URL(string: "mailto:gocarrmit2021@gmail.com")!
        UIApplication.shared.openURL(appURL)
        
    }
    
    @IBAction func question(_ sender: Any) {
        self.titleView.isHidden = true
        self.questionView.isHidden = false
        self.til.text = "FAQs"
        self.back.isHidden = false
        
    }
}
