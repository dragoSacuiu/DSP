//
//  StoreData.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation
import CoreData

class StoreData {
    let managedObjectContext = CoreDataManager(dataModelName: "DSP").managedObjectContext
}

////////////////////////////////// ACCOUNTS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension StoreData {
    
    func storeNewAccount(account: Account) {
        if !accountExistsInDataBase(account: account.id) {
        
        let accountMO = AccountEntity(context: managedObjectContext)
        accountMO.id = account.id
        accountMO.type = account.type
        accountMO.name = account.objective
        accountMO.client = account.client
        accountMO.sales = account.sales
        accountMO.contract = account.contract
        accountMO.adress1 = account.adress1
        accountMO.adress2 = account.adress2
        accountMO.city = account.city
        accountMO.county = account.county
        accountMO.technic = account.technic
        accountMO.system = account.system
        accountMO.comunicator = account.comunicator
        accountMO.reciver = account.reciver
        accountMO.longitude = account.longitude
        accountMO.latitude = account.latitude
        accountMO.periodicTest = account.periodicTest
        } else {
            print("Cannot create account, account exists")
        }
        saveAccount()
    }
}

/////////////////////////////// EVENTS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension StoreData {
    
    func storeEvents(accountEvents: AccountEvents) {
        let accountMO = getAccountMO(accountId: accountEvents.id)
        for event in accountEvents.events {
            let eventMO = EventEntity(context: managedObjectContext)
            eventMO.setValue(event.date, forKey: "date")
            eventMO.setValue(event.name, forKey: "eventName")
            eventMO.setValue(event.cid, forKey: "cid")
            eventMO.setValue(event.group, forKey: "group")
            eventMO.setValue(event.partition, forKey: "partition")
            eventMO.setValue(event.zoneOrUser, forKey: "zoneOrUser")
            eventMO.setValue(event.priority, forKey: "priority")
            accountMO.addToEvents(eventMO)
        }
    }
}

///////////////////////////// STORE DATA GLOBAL FUNCTIONS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension StoreData {
    
    func storeAccoutEvents(accoutsEvents: [AccountEvents]) {
        for account in accoutsEvents {
            let fetchAccount = getAccountMO(accountId: account.id)
            if fetchAccount.id == account.id {
                storeEvents(accountEvents: account)
            }
        }
    }
    
    func saveAccount() {
        do {
            try managedObjectContext.save()
        } catch  {
            fatalError("couldn't save data")
        }
    }
    
    func getAccountMO(accountId: String) -> AccountEntity {
        let fetchDescription = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountEntity")
        do {
            let fetchResult = try managedObjectContext.fetch(fetchDescription) as! [AccountEntity]
            for accountMO in fetchResult {
                if accountMO.id == accountId {
                    return accountMO
                }
            }
        } catch  {
            print("Account dose not exists in database")
        }
        return AccountEntity(context: managedObjectContext)
    }
    
    func accountExistsInDataBase (account: String) -> Bool {
        let fetchAccount = getAccountMO(accountId: account).id
        guard fetchAccount == account else {
            return false
        }
        return true
    }
}

