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
    private var cars : [Car] = []
    private var locations : [parking_location] = []
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
                    self.cars.append(Car(rego: document.documentID, condition: condition, model: model, leased: leased, parking_location: parking_location, rate: rate, vehicle_type: vehicle_type))
                //    print(model.lowercased().trimmingCharacters(in: .whitespaces))
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
    
    public func getCars() -> [Car]{
        
        return self.cars
    }
    public func getLocation() -> [parking_location]{
        
        return self.locations
        
    }
    
    public func retrievingAll(){
        retrievingLocation()
        retrievingCars()
    }
    
}

