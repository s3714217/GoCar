//
//  GoCarTests.swift
//  GoCarTests
//
//  Created by Thien Nguyen on 5/3/21.
//

import XCTest
@testable import GoCar

class GoCarTests: XCTestCase {

    
    var db = DBService()
    var test_user = User()
    var test_car = Car()
    var trans = Transaction()
    override func setUp() {
        db.retrievingAll()
        test_user.email = "user@test.com"
        test_user.fullName = "Test User"
        test_user.phone_number = "0400123456"
        test_user.renting = false
        test_user.userID = "TEST"
        test_user.verified = "verified"
        var history = History()
        history.amount = 100
        history.carID = "00000"
        history.carModel = "TEST MODEL"
        test_user.history.append(history)
        test_car.rego = "00000"
        test_car.condition = "good"
        test_car.leased = false
        test_car.model = "TEST MODEL"
        test_car.rate  = 100
        test_car.vehicle_type = "TEST TYPE"
        trans.carID = test_car.rego
        trans.amount = 1000
        trans.id = "12123123"
        trans.return_address = "TEST ADDRESS"
    }
    
    override func tearDown() {
        db.db.collection("users").document("TEST").delete()
    }
    
    func testRetrievingCars(){
        var TIMEOUT = 5
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ timer in
            if TIMEOUT == 0{
                timer.invalidate()
                XCTAssert(self.db.getCars().count > 1)
            }
            TIMEOUT -= 1
        }
    }
    func testRetrievingLocations(){
        var TIMEOUT = 5
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ timer in
            if TIMEOUT == 0{
                timer.invalidate()
                XCTAssert(self.db.getLocation().count > 1)
            }
            TIMEOUT -= 1
        }
    }
    
    func testUserData(){
        db.addUserInfo(userID: "TEST", fullName: "Test User", email: "user@test.com")
        db.retrieveUserInformation(userID: "TEST")
       
        var TIMEOUT = 5
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ timer in
            if TIMEOUT == 0{
                timer.invalidate()
                XCTAssert(self.db.getUser().userID == "TEST")
            }
            TIMEOUT -= 1
        }
    }
    
    func testTransactionData(){
        var trans = Transaction()
        trans.carID = test_car.rego
        trans.amount = 1000
        trans.id = "12123123"
        trans.return_address = "TEST ADDRESS"
        db.addTransaction(user: test_user, car: test_car, transaction: trans)
        db.retrieveTransaction(userID: test_user.userID)
        var TIMEOUT = 5
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ timer in
            if TIMEOUT == 0{
                timer.invalidate()
                XCTAssert(self.db.getTransaction().id == "12123123")
            }
            TIMEOUT -= 1
        }
        
    }
    func testFinishReturning(){
        db.finishReturning(userID: test_user.userID, transaction: self.trans, car: self.test_car, address: self.test_car.parking_location, image: UIImage(imageLiteralResourceName: "honda cr-v"))
        db.retrieveUserInformation(userID: test_user.userID)
        var TIMEOUT = 5
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ timer in
            if TIMEOUT == 0{
                timer.invalidate()
                XCTAssert(self.db.getUser().history[0].carID == self.test_car.rego)
            }
            TIMEOUT -= 1
        }
    }
}
