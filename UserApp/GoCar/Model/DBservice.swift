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
    
    var db = Firestore.firestore()
    private var cars : [Car] = []
    private var locations : [parking_location] = []
    private var user: User = User()
    private var transaction = Transaction()
    
    
    public init(){
    
    }
    
    public func addUserInfo(userID: String, fullName: String, email: String){
        
        self.db.collection("users").document(userID).setData([
            "fullName": fullName,
            "verified": "unverified",
            "contactEmail": email,
            "phoneNumber": "",
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
    
    public func retrievingAvailableCars(){
      
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
    
    public func retreivingAllCars(){
        self.cars = []
        db.collection("cars").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let condition = document.get("condition") as! String
                    let leased = document.get("leased") as! Bool
                    let model = document.get("model") as! String
                    let parking_location = document.get("parking_location") as! String
                    let rate = document.get("rate") as! Int
                    let vehicle_type = document.get("vehicle_type") as! String
                    self.cars.append(Car(rego: document.documentID, condition: condition, model: model, leased: leased, parking_location: parking_location, rate: rate, vehicle_type: vehicle_type))
                }
               
            }
           
        }
    }
    
    public func sortingCars(){
        for i in 0...self.locations.count - 1{
            for car in self.cars{
                if car.parking_location == self.locations[i].address {
                    self.locations[i].cars.append(car)
                    self.locations[i].car_count += 1
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
                   
                    self.locations.append(parking_location(parkID: document.documentID, address: address, lat: location.latitude, long: location.longitude, car_count: 0))
                }
               
            }
           
        }
    }
    
    public func retrieveUserInformation(userID: String) {
        var docRef = db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                self.user.email = document.get("contactEmail") as!String
                self.user.fullName = document.get("fullName") as! String
                self.user.verified = document.get("verified") as! String
                self.user.renting = document.get("renting") as! Bool
                self.user.phone_number = document.get("phoneNumber") as! String
                
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
                self.user.card.cardNumber = ""
                self.user.card.cvv = ""
                self.user.card.date = ""
                print("Card does not exist")
            }
        }
        
        db.collection("users").document(userID).collection("history").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var temp_hist = History()
                    temp_hist.id = document.documentID
                    temp_hist.carModel = document.get("carModel") as! String
                    temp_hist.amount = document.get("amount") as! Int
                    temp_hist.carID = document.get("carID") as! String
                    temp_hist.imageRef = document.get("imageRef") as! String
                    temp_hist.return_address = document.get("return_address") as! String
                    temp_hist.returnDate = (document.get("return_date") as! Timestamp).dateValue()
                    temp_hist.startDate = (document.get("start_date") as! Timestamp).dateValue()
                    self.user.history.append(temp_hist)
                }
               
            }
           
        }
    }
    
    public func addPayment(user:User){
        self.db.collection("users").document(user.userID).collection("card").document("payment").setData([
            "card_number": user.card.cardNumber,
            "cvv": user.card.cvv,
            "date": user.card.date
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
                print("SUCCESSFULLY updating user")
            }
        }
    }

    public func addTransaction(user: User, car: Car, transaction: Transaction){
       let doc = self.db.collection("transaction").document()
       doc.setData([
            "carID": car.rego,
            "amount": transaction.numberOfDate * car.rate,
            "return_date": transaction.returnDate,
            "start_date": transaction.startDate,
            "userID": user.userID,
            "return_address": "none"
        
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
                print("SUCCESSFULLY adding transaction")
            }
        }
        
        
        self.db.collection("cars").document(car.rego).updateData(["leased" : true])
        
        self.db.collection("users").document(user.userID).updateData(["renting": true, "current_transaction": doc.documentID])
    }
    
    
    
    public func submitVerificationForm(user: User, image: UIImage){
        
        self.db.collection("users").document(user.userID).setData([
            "fullName": user.fullName,
            "renting": false,
            "phoneNumber": user.phone_number,
            "contactEmail": user.email,
            "verified": "pending",
            "imageRef": user.userID
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
             }

        }
                           
    }
    
    public func finishReturning(userID: String, transaction: Transaction, car: Car, address: String, image:UIImage){
        
        self.db.collection("users").document(userID).collection("history").document(transaction.id).setData([
            "carModel": car.model,
            "carID": transaction.carID,
            "start_date": transaction.startDate,
            "return_date": Date(),
            "return_address": transaction.return_address,
            "amount": transaction.amount,
            "imageRef": transaction.id
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
                print("SUCCESSFULLY updating user")
            }
        }
        
        self.db.collection("transaction").document(transaction.id).delete()
        self.db.collection("cars").document(car.rego).updateData(["leased" : false, "parking_location" : address])
        self.db.collection("users").document(userID).updateData(["current_transaction" : "", "renting" : false])
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var data = NSData()
        data = image.jpegData(compressionQuality: 0.8)! as NSData
        let filePath = "transaction/\(userID)/\(transaction.id)"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
             if let error = error {
                 print(error.localizedDescription)
                 return
             }

        }
        
    }
    
    public func retrieveTransaction(userID: String)
    {
        var transaction_id = ""
        
        var docRef = db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let renting = document.get("renting") as! Bool
                if !renting{
                    return
                }
                
                transaction_id = document.get("current_transaction") as? String ?? " "
                self.transaction.id = transaction_id
                docRef =  self.db.collection("transaction").document(transaction_id)

                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        
                        self.transaction.carID = document.get("carID") as! String
                        self.transaction.amount = document.get("amount") as! Int
                        self.transaction.return_address = document.get("return_address") as! String
                        
                        let re_date = document.get("return_date") as! Timestamp
                        
                        let st_date = document.get("start_date") as! Timestamp
                        
                        self.transaction.return_address = document.get("return_address") as! String
                        
                        self.transaction.returnDate = re_date.dateValue()
                        self.transaction.startDate = st_date.dateValue()
                        
                        let numberOfDate = Calendar.current.dateComponents([.day], from: self.transaction.startDate, to: self.transaction.returnDate)
                        self.transaction.numberOfDate = numberOfDate.day!
                    
                    } else {
                        
                        print("data does not exist")
                    }
                }
            } else {
                print("User does not exist")
            }
        }
        
       
    }
    
    public func sendEmailConfirmation(user: User, trans: Transaction, selectedCar: Car){
        
         self.db.collection("mail").document().setData([
            "to": user.email,
            "message": [
                "subject": "Booking Confirmation",
                "text": "Hi \(user.fullName),\n \nThis is the confirmation for your booked vehicle below \n\n Car Model: \(selectedCar.model) \n\n Registration No: \(selectedCar.rego) \n\n Address:  \(selectedCar.parking_location) \n \nThank you your booking \n \nGoCar Team"
            ]

         ])
         { err in
             if let err = err {
                 print("THERE IS AN ERROR \(err)")
             }
             else{

             }
         }

    }
    
    public func sendFinishTrip(user: User, trans: Transaction, overdueCost: Int){
        
        if overdueCost > 0 {
            self.db.collection("mail").document().setData([
               "to": user.email,
               "message": [
                   "subject": "Trip Receipt",
                "text": "Hi \(user.fullName), \n \nThank you for complete your trip with GoCar, please find your trip summary bellow \n\nTransaction ID: \(trans.id) \n\nCar ID: \(trans.carID) \n\nPaid Amount: \(trans.amount) \n\nOverdue Fee: \(overdueCost) \n\nPlease email us if there is any issue related to the transaction \n\nGoCar Team "

               ]

            ])
            { err in
                if let err = err {
                    print("THERE IS AN ERROR \(err)")
                }
                else{
                    print("SUCCESSFULLY adding transaction")
                }
            }
        }
        else{
            self.db.collection("mail").document().setData([
               "to": user.email,
               "message": [
                   "subject": "Trip Receipt",
                "text": "Hi \(user.fullName), \n \nThank you for complete your trip with GoCar, please find your trip summary bellow \n\nTransaction ID: \(trans.id) \n\nCar ID: \(trans.carID) \n\nPaid Amount: \(trans.amount) \n\nPlease email us if there is any issue related to the transaction \n\nGoCar Team "

               ]

            ])
            { err in
                if let err = err {
                    print("THERE IS AN ERROR \(err)")
                }
                else{
                    print("SUCCESSFULLY adding transaction")
                }
            }

        }
    }
    
    public func sendVerificationCode(email: String, code: String){
        self.db.collection("mail").document().setData([
           "to": email,
           "message": [
               "subject": "Verification Code",
               "text": "Your Verifcation Code is \(code) "
           ]
           
        ])
        { err in
            if let err = err {
                print("THERE IS AN ERROR \(err)")
            }
            else{
               
            }
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
    
    public func getTransaction() -> Transaction{
        return self.transaction
    }
    
    public func retrievingAll(){
        retrievingLocation()
        retrievingAvailableCars()
    }
    
    public func processPayment(card: CreditCard, amount: Int) -> Bool{
        return true
    }
    
}

