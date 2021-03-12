//
//  DBservice.swift
//  GoCar
//
//  Created by Thien Nguyen on 8/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DBService{
    
    private var db = Firestore.firestore()
    let EXCEPTION = 0
    let EMAIL_EXISTED = 1
    let WRONG_PASSWORD = 2
    let MISSING_VALUE = 3
    let PASSED = 4
    let REJECTED = 5
    
    public init(){
    
    }
    
    public func addUserInfo(userID: String, fullName: String){
        
        self.db.collection("users").document(userID).setData([
            "fullName": fullName,
            "renting": false
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
                print("SUCCESSFULLY ADDED user")
            }
        }

    }
    
    public func addCreditCard(userID: String, card:CreditCard){
        
        self.db.collection("users").document(userID).collection("creditcard").document("payment").setData([
            "cardNumber": card.cardNumber,
            "cvv": card.cvv,
            "date": card.date
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
                print("SUCCESSFULLY ADDED credit card")
            }
        }
        
    }
    
    public func addHistory(userID: String, history: History){
        self.db.collection("users").document(userID).collection("history").document(history.returnDate).setData([
            "carRef": history.carRef,
            "duration": history.duration
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
                print("SUCCESSFULLY ADDED history")
            }
        }
        
    }

}

