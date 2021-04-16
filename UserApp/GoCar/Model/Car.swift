//
//  Car.swift
//  GoCar
//
//  Created by Thien Nguyen on 19/3/21.
//

import Foundation

public struct Car{
    var rego: String
    var condition : String
    var leased: Bool
    var model: String
    var parking_location: String
    var rate: Int
    var vehicle_type: String
    
    init(rego: String,
        condition: String,
        model: String,
        leased: Bool,
        parking_location: String,
        rate: Int,
        vehicle_type: String) {
        
        self.rego = rego
        self.condition = condition
        self.leased = leased
        self.model = model
        self.parking_location = parking_location
        self.rate = rate
        self.vehicle_type = vehicle_type
    }
    init() {
        self.rego = ""
        self.condition = ""
        self.leased = false
        self.model = ""
        self.parking_location = ""
        self.rate = 0
        self.vehicle_type = ""
    }
}

public struct parking_location{
    var parkID : String
    var address: String
    var lat: Double
    var long: Double
    var car_count: Int
    var cars: [Car]
    var suburd: String
    
    init(parkID : String,
         address: String,
         lat: Double,
         long: Double,
         car_count: Int
    ) {
        self.parkID = parkID
        self.address = address
        self.lat = lat
        self.long = long
        self.car_count = car_count
        self.cars = []
        self.suburd = ""
        
        var adding = false
        for c in address{
            if adding == true {
                self.suburd.append(c)
            }
            if c == "," {
                adding = true
            }
            
            if suburd.count > 2 && c == " "{
                adding = false
            }
        }
    }
    init() {
        self.parkID = ""
        self.address = ""
        self.lat = 0
        self.long = 0
        self.car_count = 0
        self.cars = []
        self.suburd = ""
    }
}
