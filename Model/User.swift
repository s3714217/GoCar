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
    
    init(fullName: String, userID: String) {
        self.fullName = fullName
        self.userID = userID
        self.card = CreditCard(cardNumber: "", cvv: "", date: "")
        self.history = []
        self.renting = false
    }
    
    init(fullName: String, userID: String, card: CreditCard, rent: Bool) {
        self.fullName = fullName
        self.userID = userID
        self.card = card
        self.history = []
        self.renting = rent
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
    
    var carRef: String
    var duration: Int64
    var returnDate: String
    
    init(carRef: String, duration: Int64, returnDate: String) {
        self.carRef = carRef
        self.duration = duration
        self.returnDate = returnDate
    }
    init() {
        self.carRef = ""
        self.duration = 0
        self.returnDate = ""
    }
}
