//
//  User.swift
//  GoCar
//
//  Created by Thien Nguyen on 8/3/21.
//

import Foundation

public struct User{
    
    var fullName: String
    var userID : String
    var card: CreditCard
    var history: [History]
    var renting: Bool
    var verified: String
    var email = ""
    var phone_number = ""
    
    init(fullName: String, userID: String) {
        self.fullName = fullName
        self.userID = userID
        self.card = CreditCard(cardNumber: "", cvv: "", date: "")
        self.history = []
        self.renting = false
        self.verified = ""
    }
    
    init(fullName: String, userID: String, card: CreditCard, rent: Bool) {
        self.fullName = fullName
        self.userID = userID
        self.card = card
        self.history = []
        self.renting = rent
        self.verified = ""
    }
    init(fullName: String, userID: String, rent: Bool) {
        self.fullName = fullName
        self.userID = userID
        self.renting = rent
        self.card = CreditCard()
        self.history = []
        self.verified = ""
    }
    
}

public struct CreditCard{
    
    var cardNumber: String
    var cvv: String
    var date: String
    
    init(cardNumber: String, cvv: String, date: String) {
        self.cardNumber = cardNumber
        self.cvv = cvv
        self.date = date
    }
    
    init() {
        self.cardNumber = ""
        self.cvv = ""
        self.date = ""
    }
}

public struct History{
    
    
    var startDate : Date
    var returnDate : Date
    var return_address: String
    var amount: Int
    var carID: String
    var imageRef: String
    init() {
     
        self.startDate = Date()
        self.returnDate = Date()
        self.amount = 0
        self.carID = ""
        self.return_address = ""
        self.imageRef = ""
    }
}

public struct Transaction{
    var id : String
    var startDate : Date
    var returnDate : Date
    var amount: Int
    var carID: String
    var userID: String
    var numberOfDate: Int
    var return_address: String
    
    init(){
        self.id = ""
        self.startDate = Date()
        self.returnDate = Date()
        self.amount = 0
        self.carID = ""
        self.userID = ""
        self.numberOfDate = 0
        self.return_address = ""
    }
    
    
}
