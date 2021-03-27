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
    
    var carRef: String
    var totalCost: Double
    var startDate: String
    var returnDate: String
    
    init(carRef: String, totalCost:Double, returnDate: String, startDate: String) {
        self.carRef = carRef
        self.totalCost = totalCost
        self.returnDate = returnDate
        self.startDate = startDate
    }
    init() {
        self.carRef = ""
        self.totalCost = 0
        self.returnDate = ""
        self.startDate = ""
    }
}
