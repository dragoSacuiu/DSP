//
//  AddAccountViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 28/11/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class AddAccountViewController: NSViewController {
    let storeData = StoreData()
    
    var copyedAccount: Account? = nil
    
    @IBOutlet weak var account: NSTextField!
    @IBOutlet weak var type: NSTextField!
    @IBOutlet weak var objective: NSTextField!
    @IBOutlet weak var client: NSTextField!
    @IBOutlet weak var sales: NSTextField!
    @IBOutlet weak var contract: NSTextField!
    @IBOutlet weak var street: NSTextField!
    @IBOutlet weak var building: NSTextField!
    @IBOutlet weak var city: NSTextField!
    @IBOutlet weak var county: NSTextField!
    @IBOutlet weak var technic: NSTextField!
    @IBOutlet weak var system: NSTextField!
    @IBOutlet weak var comunicator: NSTextField!
    @IBOutlet weak var reciver: NSTextField!
    @IBOutlet weak var longitude: NSTextField!
    @IBOutlet weak var latitude: NSTextField!
    
    @IBOutlet weak var test24HOutlet: NSButton!
    @IBOutlet weak var test12HOutlet: NSButton!
    @IBOutlet weak var test6HOutlet: NSButton!
    @IBOutlet weak var test3HOutlet: NSButton!
    
    @IBAction func periodicTestChanged(_ sender: AnyObject) {
        
    }
    
    @IBAction func addEmiLocation(_ sender: Any) {
    }
    @IBAction func addClientLocation(_ sender: Any) {
    }
    @IBAction func autoAddLocation(_ sender: Any) {
    }
    @IBAction func resetLocation(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    @IBAction func save(_ sender: Any) {
        let periodicTest = getPeriodicTest()
        let newAccount = Account(id: account.stringValue , type: type.stringValue, objective: objective.stringValue, client: client.stringValue, sales: sales.stringValue, contract: contract.stringValue, adress1: street.stringValue, adress2: building.stringValue, city: city.stringValue, county: county.stringValue, technic: technic.stringValue, system: system.stringValue, comunicator: comunicator.stringValue, reciver: reciver.stringValue, longitude: longitude.stringValue, latitude: latitude.stringValue, periodicTest: periodicTest)
        
        storeData.storeNewAccount(account: newAccount)
    }
    
    func getPeriodicTest() -> String {
        let periodicTestOutlets = [test24HOutlet, test12HOutlet, test6HOutlet, test3HOutlet]
        var selectedPeriodicTestValue: NSButton?
        for periodicTestOutlet in periodicTestOutlets {
            if periodicTestOutlet!.state == .on {
                selectedPeriodicTestValue = periodicTestOutlet
                break
            } else {
                print("No periodic test selected")
            }
        }
        switch selectedPeriodicTestValue {
        case test24HOutlet:
            return "24H"
        case test12HOutlet:
            return "12H"
        case test6HOutlet:
            return "6H"
        case test3HOutlet:
            return "3H"
        default:
            return ""
        }
    }
    
    @IBAction func copyAccountButton(_ sender: NSButton) {
        let periodicTest = getPeriodicTest()
        
        copyedAccount = Account(id: account.stringValue , type: type.stringValue, objective: objective.stringValue, client: client.stringValue, sales: sales.stringValue, contract: contract.stringValue, adress1: street.stringValue, adress2: building.stringValue, city: city.stringValue, county: county.stringValue, technic: technic.stringValue, system: system.stringValue, comunicator: comunicator.stringValue, reciver: reciver.stringValue, longitude: longitude.stringValue, latitude: latitude.stringValue, periodicTest: periodicTest)
    }
    
    @IBAction func pasteAccountButton(_ sender: NSButton) {
        if copyedAccount != nil {
            self.account.stringValue = copyedAccount!.id
            self.type.stringValue = copyedAccount!.type
            self.objective.stringValue = copyedAccount!.objective
            
            
        }
    }
    
}

