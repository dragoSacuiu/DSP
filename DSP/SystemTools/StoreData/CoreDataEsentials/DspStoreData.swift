//
//  StoreEvents.swift
//  DSP
//
//  Created by Sacuiu Dragos on 05/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Foundation
import CoreData

class DspStoreData {
    let dspAlert = DspAlert()
    let managedObjectContext = CoreDataManager(dataModelName: "DSP").managedObjectContext
    
}

extension DspStoreData {
    
    func addUndefinedAccountToBlackList(accountID: String) {
        let newUndefinedAccount = NSEntityDescription.insertNewObject(forEntityName: "BlackListEntity", into: managedObjectContext) as? BlackListEntity
        newUndefinedAccount?.accountID = accountID
        dspAlert.showAlert(message: "DSP: Account ID: \(accountID) was added to the BlackList.")
        saveContext()
    }
    
    func getBlackList() -> [String] {
        var accountIDs = [String]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BlackListEntity")
        do {
            let blackList = try managedObjectContext.fetch(fetchRequest) as! [BlackListEntity]
            for account in blackList {
                accountIDs.append(account.accountID!)
            }
            return accountIDs
        } catch {
            dspAlert.showAlert(message: "DSP: Can't get BlackList")
        }
        return []
    }
    
    func removeAccountIDFromBlackList(accountID: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BlackListEntity")
        fetchRequest.predicate = NSPredicate(format: "accountID == %@", accountID)
        do {
            let blackList = try managedObjectContext.fetch(fetchRequest) as! [BlackListEntity]
            for account in blackList {
                if account.accountID == accountID {
                    managedObjectContext.delete(account)
                    dspAlert.showAlert(message: "DSP: Account ID: \(accountID) was removed from BlackList.")
                    saveContext()
                }
            }
        } catch {
            dspAlert.showAlert(message: "DSP: Can't get BlackList")
        }
    }
    
    func storeAccountEvents(accoutsEvents: [AccountEvents]) {
        for accountEvents in accoutsEvents {
            let fetchAccount = getAccount(accountId: accountEvents.id)
            guard fetchAccount == nil else {
                if fetchAccount!.id == accountEvents.id {
                    for event in accountEvents.events {
                        let eventEntity = EventEntity(context: managedObjectContext)
                        eventEntity.date = event.date
                        eventEntity.eventName = event.name
                        eventEntity.cid = event.cid
                        eventEntity.group = Int16(event.group)
                        eventEntity.partition = Int16(event.partition)
                        eventEntity.zoneOrUser = Int16(event.zoneOrUser)
                        eventEntity.priority = Int16(event.priority)
                        fetchAccount!.addToEvents(eventEntity)
                    }
                }
                return
            }
        }
    }
    
    func getAccount(accountId: String) -> AccountEntity? {
        var foundAccount = false
        let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", accountId)
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest)
            for account in fetchResult {
                if account.id == accountId {
                    foundAccount = true
                    return account
                }
            }
            guard foundAccount else {
                dspAlert.showAlert(message: "DSP: Didn't found Account ID: \(accountId)")
                return nil
            }
        } catch  {
            print("DSP: Cant get accounts")
        }
       return nil
    }
    
    func storeEmi(id: String, phone: String, active: Bool, statusDetails: String, longitude: Double, latitude: Double) {
        let emi = NSEntityDescription.insertNewObject(forEntityName: "EmiEntity", into: managedObjectContext) as! EmiEntity
        emi.id = id
        emi.phone = phone
        emi.active = active
        emi.statusDetails = statusDetails
        emi.longitude = longitude
        emi.latitude = latitude
        saveContext()
    }
    
    func getEmi() -> EmiEntity? {
        return nil
    }
    
    func getEmis() -> [EmiEntity]? {
        let activeSortDescriptor = NSSortDescriptor(key: "active", ascending: false)
        let idSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmiEntity")
        fetchRequest.sortDescriptors = [activeSortDescriptor, idSortDescriptor]
        do {
           return try managedObjectContext.fetch(fetchRequest) as? [EmiEntity]
        } catch {
            dspAlert.showAlert(message: "Can't get EMI's from data base")
        }
        return nil
    }
    
    func deleteAccount(account: AccountEntity) {
        managedObjectContext.delete(account)
    }
    
    func deleteEmi(selectedEmiIndex: Int) {
        var emis = getEmis()
        managedObjectContext.delete(emis![selectedEmiIndex])
        saveContext()
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch  {
            fatalError("DSP: Couldn't save data")
        }
    }
    
}
