//
//  DBservice.swift
//  GoCar
//
//  Created by Thien Nguyen on 8/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
class DBService{
    
    private var db = Firestore.firestore()
    private var cars : [Car] = []
    private var locations : [parking_location] = []
    private var user: User = User(fullName: "", userID: "")
    public init(){
    
    }
    
    public func addUserInfo(userID: String, fullName: String){
        
        self.db.collection("users").document(userID).setData([
            "fullName": fullName,
            "verified": "unverified",
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
            "cost": history.totalCost,
            "startDate": history.startDate,
            "returnDate": history.returnDate
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
    
    public func retrievingCars(){
      
        db.collection("cars").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                 //   print("\(document.documentID) => \(document.data())")
                    let condition = document.get("condition") as! String
                    let leased = document.get("leased") as! Bool
                    let model = document.get("model") as! String
                    let parking_location = document.get("parking_location") as! String
                    let rate = document.get("rate") as! Int
                    let vehicle_type = document.get("vehicle_type") as! String
                    if !leased{
                        self.cars.append(Car(rego: document.documentID, condition: condition, model: model, leased: leased, parking_location: parking_location, rate: rate, vehicle_type: vehicle_type))
                    }
                }
               
            }
           
        }
    }
    public func sortingCars(){
        for i in 0...self.locations.count - 1{
            for car in self.cars{
                if car.parking_location == self.locations[i].address {
                    self.locations[i].cars.append(car)
                }
            }
        }
     
    }
    public func retrievingLocation() {
        db.collection("parking_location").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let address = document.get("Address") as! String
                    let location = document.get("Location") as! GeoPoint
                    let number = document.get("Number_cars") as! Int
                    self.locations.append(parking_location(parkID: document.documentID, address: address, lat: location.latitude, long: location.longitude, car_count: number))
                }
               
            }
           
        }
    }
    
    public func retrieveUserInformation(userID: String) {
        var docRef = db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let fullName = document.get("fullName") as! String
                let verified = document.get("verified") as! String
                let renting = document.get("renting") as! Bool
                
                self.user.fullName = fullName
                self.user.verified = verified
                self.user.renting = renting
                
            } else {
                print("User does not exist")
            }
        }
        
        docRef = db.collection("users").document(userID).collection("card").document("payment")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let card_number = document.get("card_number") as! String
                let cvv = document.get("cvv") as! String
                let date = document.get("date") as! String
                
                self.user.card.cardNumber = card_number
                self.user.card.cvv = cvv
                self.user.card.date = date
               
            } else {
                print("Card does not exist")
            }
        }
        
        db.collection("users").document(userID).collection("history").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let carRef = document.get("carRef") as! String
                    let totalCost = document.get("totalCost") as! Double
                    let returnDate = document.get("returnDate") as! String
                    let startDate = document.get("startDate") as! String
                    self.user.history.append(History(carRef: carRef, totalCost: totalCost, returnDate: returnDate, startDate: startDate))
                }
               
            }
           
        }
    }
    
    public func submitVerificationForm(user: User, image: UIImage){
        self.db.collection("verificationForm").document(user.userID).setData([
            "fullName": user.fullName,
            "phoneNumber": user.phone_number,
            "contactEmail": user.email,
            "imageRef": user.userID
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
                print("SUCCESSFULLY submitted verification form")
            }
        }
        self.db.collection("users").document(user.userID).setData([
            "fullName": user.fullName,
            "renting": false,
            "phoneNumber": user.phone_number,
            "contactEmail": user.email,
            "verified": "pending"
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
                print("SUCCESSFULLY updating user")
            }
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var data = NSData()
        data = image.jpegData(compressionQuality: 0.8)! as NSData
            // set upload path
        let filePath = "verification/\(user.userID)/licence"
         let metaData = StorageMetadata()
         metaData.contentType = "image/jpg"
        storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
             if let error = error {
                 print(error.localizedDescription)
                 return
             }else{}

             }
                           
    }
    
    public func getCars() -> [Car]{
        
        return self.cars
    }
    public func getLocation() -> [parking_location]{
        return self.locations
    }
    
    public func getUser() -> User{
        return self.user
    }
    
    public func retrievingAll(){
        retrievingLocation()
        retrievingCars()
    }
    
}

