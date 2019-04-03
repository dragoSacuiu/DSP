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
    
    func storeActionDetails(account: AccountEntity, emiId: String, solution: String, details: String) {
        let newDetails = NSEntityDescription.insertNewObject(forEntityName: "ActionDetailesEntity", into: managedObjectContext) as! ActionDetailesEntity
        newDetails.date = NSDate()
        newDetails.user = UsersManager.activeUser
        newDetails.emi = emiId
        newDetails.solution = solution
        newDetails.detailes = details
        account.addToActionDetailes(newDetails)
        saveContext()
    }
    
    func storeEmi(id: String, phone: String, status: String, statusDetails: String, longitude: Double, latitude: Double) {
        let emi = NSEntityDescription.insertNewObject(forEntityName: "EmiEntity", into: managedObjectContext) as! EmiEntity
        emi.id = id
        emi.phone = phone
        emi.status = status
        emi.statusDetails = statusDetails
        emi.longitude = longitude
        emi.latitude = latitude
        saveContext()
    }
    
    func storeTicket(account: AccountEntity, content: String) {
        let newTicket = NSEntityDescription.insertNewObject(forEntityName: "TicketEntity", into: managedObjectContext) as! TicketEntity
        newTicket.date = NSDate()
        newTicket.user = UsersManager.activeUser
        newTicket.number = getTicketNumber()
        newTicket.manager = account.manager
        newTicket.status = "OPEN"
        newTicket.type = "AUTO"
        newTicket.details = content
        account.addToTickets(newTicket)
        saveContext()
    }
    
    func getTicketNumber() -> Int64 {
        let fetchDescription = NSFetchRequest<NSFetchRequestResult>(entityName: "TicketNumberEntity")
        do {
            let fetchResult = try managedObjectContext.fetch(fetchDescription) as! [TicketNumberEntity]
            if fetchResult.count == 0 {
                let firstTicketNumber = NSEntityDescription.insertNewObject(forEntityName: "TicketNumberEntity", into: managedObjectContext) as! TicketNumberEntity
                firstTicketNumber.number = 1000000
                saveContext()
                return firstTicketNumber.number
            } else {
                fetchResult[0].number += 1
                return fetchResult[0].number
            }
        } catch {
            dspAlert.showAlert(message: "Cannot get ticket number from database")
        }
        return 0
    }
    
    func getManagers() -> [ManagerEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagerEntity")
        do {
            return try managedObjectContext.fetch(fetchRequest) as! [ManagerEntity]
        } catch  {
            dspAlert.showAlert(message: "Can't get managers list from database")
        }
        return []
    }
    
    func getEmi(selectedEmiIndex: Int) -> EmiEntity? {
        let emis = getEmis()
        return emis![selectedEmiIndex]
    }
    
    func getEmis() -> [EmiEntity]? {
        let activeSortDescriptor = NSSortDescriptor(key: "status", ascending: false)
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
    
    
    func deleteEmi(emi: EmiEntity) {
        managedObjectContext.delete(emi)
        saveContext()
    }

    func deleteActions() {
        let fechRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ActionDetailesEntity")
        do {
            let x = try managedObjectContext.fetch(fechRequest) as! [ActionDetailesEntity]
            for y in x {
                managedObjectContext.delete(y)
            }
            saveContext()
        } catch  {
            print("")
        }
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch  {
            fatalError("DSP: Couldn't save data")
        }
    }
    
}
