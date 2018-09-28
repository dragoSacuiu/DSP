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
    let coreDataManager = CoreDataManager(dataModelName: "Dispatch")
    
    func storeEvents(AccountEvents: [AccountEvents]) {
        for account in AccountEvents {
            let accountMO = storeAccount(Account: account.id)
            for event in account.events {
                let eventMOEntity = NSEntityDescription.entity(forEntityName: "EventMo", in: coreDataManager.managedObjectContext)
                let eventMO = EventMO(entity: eventMOEntity!, insertInto: coreDataManager.managedObjectContext)
                eventMO.setValue(event.date, forKey: "date")
                eventMO.setValue(event.eventName, forKey: "eventName")
                eventMO.setValue(event.cid, forKey: "cid")
                eventMO.setValue(event.group, forKey: "group")
                eventMO.setValue(event.partition, forKey: "partition")
                eventMO.setValue(event.zoneOrUser, forKey: "zoneOrUser")
                eventMO.setValue(event.eventType, forKey: "eventType")
                accountMO.addToEvents(eventMO)
            }
        }
    }
    
    func storeAccount(Account: String) -> AccountMO {
        var accountMO = AccountMO(context: coreDataManager.managedObjectContext)
        let accountsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountMO")
        do {
            let requestedData = try coreDataManager.managedObjectContext.fetch(accountsFetchRequest)
            for account in requestedData as! [AccountMO] {
                if (account.value(forKey: "id") as! String) == Account{
                    accountMO = account
                } else {
                    let accountMOEntity = NSEntityDescription.entity(forEntityName: "AccountMO", in: coreDataManager.managedObjectContext)
                    accountMO = AccountMO(entity: accountMOEntity!, insertInto: coreDataManager.managedObjectContext)
                }
            }
        } catch {
            print("Faild to fetch Account")
        }
        return accountMO
    }
    
    func storeUser(Name: String, Pasword: String) {
        if userExists(Name: Name) {
            print("The user already exists!")
        } else {
            let userMOEntity = NSEntityDescription.entity(forEntityName: "DSPUserMO", in: coreDataManager.managedObjectContext)
            let userMO = NSManagedObject(entity: userMOEntity!, insertInto: coreDataManager.managedObjectContext)
            userMO.setValue(Name, forKey: "name")
            userMO.setValue(Pasword, forKey: "pasword")
        }
    }
    
    func userExists(Name: String) -> Bool {
        let userFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
        do {
            let requestedData = try coreDataManager.managedObjectContext.fetch(userFetchRequest)
            for user in requestedData as! [DSPUserMO] {
                if user.name == Name {
                    return true
                }
            }
        } catch {
            print("Can't fatch Users")
        }
        return false
    }
}
