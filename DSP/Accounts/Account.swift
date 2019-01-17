//
//  File.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

struct Account {
    var id = ""
    var type = ""
    var objective = ""
    var client = ""
    var sales = ""
    var contract = ""
    var adress1 = ""
    var adress2 = ""
    var city = ""
    var county = ""
    var technic = ""
    var system = ""
    var comunicator = ""
    var reciver = ""
    var longitude = ""
    var latitude = ""
    var periodicTest = ""
    
    init(id: String, type: String, objective: String, client: String, sales: String, contract: String, adress1: String, adress2: String, city: String,
         county: String, technic: String, system: String, comunicator: String, reciver: String, longitude: String, latitude: String, periodicTest: String) {
        self.id = id
        self.type = type
        self.objective = objective
        self.client = client
        self.sales = sales
        self.contract = contract
        self.adress1 = adress1
        self.adress2 = adress2
        self.city = city
        self.county = county
        self.technic = technic
        self.system = system
        self.comunicator = comunicator
        self.reciver = reciver
        self.longitude = longitude
        self.latitude = latitude
        self.periodicTest = periodicTest
    }
    
    mutating func editId(newId: String) {
        self.id = newId
    }
    mutating func editType(newType: String) {
        self.type = newType
    }
    mutating func editObjective(newObjective: String) {
        self.objective = newObjective
    }
    mutating func editClient(newClient: String) {
        self.client = newClient
    }
    mutating func editSales(newSales: String) {
        self.sales = newSales
    }
    mutating func editContract(newContract: String) {
        self.contract = newContract
    }
    mutating func editAdress1(newAdress1: String) {
        self.adress1 = newAdress1
    }
    mutating func editAdress2(newAdress2: String) {
        self.adress2 = newAdress2
    }
    mutating func editCity(newCity: String) {
        self.city = newCity
    }
}
