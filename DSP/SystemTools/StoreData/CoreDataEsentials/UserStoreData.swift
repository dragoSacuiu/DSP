//
//  StoreData.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation
import CoreData
import Cocoa

class UserStoreData {
    let dspAlert = DspAlert()
    let managedObjectContext = CoreDataManager(dataModelName: "DSP").backgroundContext
    
    let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    let numberSortDescriptor = NSSortDescriptor(key: "number", ascending: true)
    let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    
    var account: AccountEntity?
    
    func createNewAccount() {
        account = NSEntityDescription.insertNewObject(forEntityName: "AccountEntity", into: managedObjectContext) as? AccountEntity
        createNewSchedule()
    }
    
    func getExistingAccount(accountID: String) -> Bool{
        if let searchedAccount = getAccount(accountId: accountID) {
            account = searchedAccount
            return true
        }
        return false
    }
    
///////////////////////////////////////////////////////////////////// ADD OBJECTS /////////////////////////////////////////////////////////////////////////////////////////
    func storeLocation(county: String, city: String, adress1: String, adress2: String, longitude: Double, latitude: Double) {
        let location = NSEntityDescription.insertNewObject(forEntityName: "AccountLocationEntity", into: managedObjectContext) as! AccountLocationEntity
        location.county = county
        location.city = city
        location.adress1 = adress1
        location.adress2 = adress2
        location.longitude = longitude
        location.latitude = latitude
        account!.location = location
    }
    
    func createNewSchedule() {
        let newSchedeule = NSEntityDescription.insertNewObject(forEntityName: "ScheduleEntity", into: managedObjectContext) as? ScheduleEntity
        newSchedeule!.monday = String()
        newSchedeule!.tuesday = String()
        newSchedeule!.wednesday = String()
        newSchedeule!.thursday = String()
        newSchedeule!.friday = String()
        newSchedeule!.saturday = String()
        newSchedeule!.sunday = String()
        account?.schedeule = newSchedeule
    }
    
    func storeSchedule(day: String, startTime: String, endTime: String) {
        if account?.schedeule != nil {
            switch day {
            case "MONDAY": account!.schedeule!.monday = "\(startTime) \(endTime)"
            case "TUESDAY": account!.schedeule!.tuesday = "\(startTime) \(endTime)"
            case "WEDNESDAY": account!.schedeule!.wednesday = "\(startTime) \(endTime)"
            case "THURSDAY": account!.schedeule!.thursday = "\(startTime) \(endTime)"
            case "FRIDAY": account!.schedeule!.friday = "\(startTime) \(endTime)"
            case "SATURDAY": account!.schedeule!.saturday = "\(startTime) \(endTime)"
            case "SUNDAY":account!.schedeule!.sunday = "\(startTime) \(endTime)"
            default:
                dspAlert.showAlert(message: "No such day")
            }
        } else {
            dspAlert.showAlert(message: "Schedule dose not exists")
        }
    }
    
    func storePartition(number: Int, name: String) {
        var partitionExists = false
        let partitions = account!.partitions!.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
        for partition in partitions {
            if partition.number == number {
                partitionExists = true
                dspAlert.showAlert(message: "Partition number allredy exists!")
                break
            }
        }
        guard partitionExists else {
            let newPartition = (NSEntityDescription.insertNewObject(forEntityName: "PartitionEntity", into: managedObjectContext) as! PartitionEntity)
            newPartition.number = Int16(number)
            newPartition.name = name
            account!.addToPartitions(newPartition)
            return
        }
    }
    
    func storeZone(partitionNumber: Int, newZoneNumber: Int, newZoneName: String) {
        var zoneExists = false
        let partition = getPartition(selectedPartition: partitionNumber)
        let zones = partition.zones!.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity]
        for zone in zones {
            if zone.number == newZoneNumber {
                zoneExists = true
                dspAlert.showAlert(message: "Zone number already exists!")
                break
            }
        }
        guard zoneExists else {
            let newZone = NSEntityDescription.insertNewObject(forEntityName: "ZoneEntity", into: managedObjectContext) as! ZoneEntity
            newZone.number = Int16(newZoneNumber)
            newZone.name = newZoneName
            partition.addToZones(newZone)
            return
        }
    }
    
    func storeObservation(observation: String) {
        let newObservation = NSEntityDescription.insertNewObject(forEntityName: "ObservationsEntity", into: managedObjectContext) as! ObservationsEntity
        newObservation.date = NSDate()
        newObservation.user = UsersManager.activeUser
        newObservation.observation = observation
        account!.addToObservations(newObservation)
    }
    
    func storeEmiDetail(emiDetail: String) {
        let newEmiDetail = NSEntityDescription.insertNewObject(forEntityName: "EmiDetailesEntity", into: managedObjectContext) as! EmiDetailesEntity
        newEmiDetail.date = NSDate()
        newEmiDetail.user = UsersManager.activeUser
        newEmiDetail.detailes = emiDetail
        account!.addToEmiDetails(newEmiDetail)
    }
    
    func storeContact(priority: Int16, name: String, userNumber: Int16, position: String, phoneNumber: String, email: String, observations: String) {
        let newContact = NSEntityDescription.insertNewObject(forEntityName: "ContactEntity", into: managedObjectContext) as! ContactEntity
        newContact.priority = priority
        newContact.name = name
        newContact.userNumber = userNumber
        newContact.position = position
        newContact.phoneNumber = phoneNumber
        newContact.email = email
        newContact.observations = observations
        account!.addToContacts(newContact)
    }
    
    func storeTicket(manager: String, type: String, status: String, content: String) {
        let newTicket = NSEntityDescription.insertNewObject(forEntityName: "TicketEntity", into: managedObjectContext) as! TicketEntity
        newTicket.date = NSDate()
        newTicket.user = UsersManager.activeUser
        newTicket.number = getTicketNumber()
        newTicket.manager = manager
        newTicket.status = status
        newTicket.type = type
        newTicket.details = content
        account!.addToTickets(newTicket)
    }
}
/////////////////////////////////////////////////////////////////////////// GET OBJECTS ////////////////////////////////////////////////////////////////////////////////////
extension UserStoreData {
    
    func getUsers() -> [UserEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        do {
            return try managedObjectContext.fetch(fetchRequest) as! [UserEntity]
        } catch {
            dspAlert.showAlert(message: "Can't get users list from database")
        }
        return []
    }
    
    func getManagers() -> [ManagerEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagerEntity")
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        do {
            return try managedObjectContext.fetch(fetchRequest) as! [ManagerEntity]
        } catch  {
            dspAlert.showAlert(message: "Can't get managers list from database")
        }
        return []
    }
    
    func checkAccountExists(accountId: String) -> Bool {
        let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", accountId)
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest)
            if fetchResult.count > 0 && fetchResult[0].id == accountId {
                dspAlert.showAlert(message: "Account ID: \(accountId) already exists!")
                return true
            }
        } catch  {
            print("Cant get accounts")
        }
        return false
    }
    
    func getAccount(accountId: String) -> AccountEntity? {
        let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", accountId)
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest)
            if fetchResult.count <= 1 {
                if fetchResult.count == 1 {
                    return fetchResult[0]
                } else if fetchResult.count == 0 {
                    dspAlert.showAlert(message: "AcoountID: \(accountId) dose not exists in database.")
                }
            } else {
                dspAlert.showAlert(message: "Multiple account IDs: \(accountId) ware found in database.")
            }
        } catch  {
            print("Cant get accounts")
        }
        return nil
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

    func getPartition(selectedPartition: Int) -> PartitionEntity {
        let partitions = account?.partitions?.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
        return partitions[selectedPartition]
    }
    
    func getZone(selectedPartition: Int, selectedZone: Int) -> ZoneEntity {
        let partitions = account?.partitions?.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
        let partition = partitions[selectedPartition]
        let zones = partition.zones?.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity]
        return zones[selectedZone]
    }
    
    func getObservation(selectedObservation: Int) -> ObservationsEntity {
        let observations = account?.observations?.sortedArray(using: [dateSortDescriptor]) as! [ObservationsEntity]
        guard selectedObservation >= observations.count else {
            return observations[selectedObservation]
        }
        return ObservationsEntity()
    }
    
    func getEmiDetail(selectedEmiDetailIndex: Int) -> EmiDetailesEntity {
        let emiDetails = account?.emiDetails?.sortedArray(using: [dateSortDescriptor]) as! [EmiDetailesEntity]
        guard selectedEmiDetailIndex >= emiDetails.count else {
            return emiDetails[selectedEmiDetailIndex]
        }
        return EmiDetailesEntity()
    }
    
    func getContact(selectedContact: Int) -> ContactEntity {
        let contacts = account?.contacts?.sortedArray(using: [dateSortDescriptor]) as! [ContactEntity]
        guard selectedContact >= contacts.count else {
            return contacts[selectedContact]
        }
        return ContactEntity()
    }
    
    func getTicket(selectedTicket: Int) -> TicketEntity {
        let tickets = account?.tickets?.sortedArray(using: [dateSortDescriptor]) as! [TicketEntity]
        guard selectedTicket >= tickets.count else {
            return tickets[selectedTicket]
        }
        return TicketEntity()
    }
    
}

/////////////////////////////////////////////////////////// REMOVE OBJECT ////////////////////////////////////////////////////////////////////////////////////////////////
extension UserStoreData {
    
    func removeObservation(selectedObservationIndex: Int) {
        account?.removeFromObservations(getObservation(selectedObservation: selectedObservationIndex))
    }
    func removeEmiDetail(selectedEmiDetailIndex: Int) {
        account?.removeFromEmiDetails(getEmiDetail(selectedEmiDetailIndex: selectedEmiDetailIndex))
    }
    func removeTicket(selectedTicket: Int) {
        account?.removeFromTickets(getTicket(selectedTicket: selectedTicket))
    }
    func removeContact(selectedContact: Int) {
        account?.removeFromContacts(getContact(selectedContact: selectedContact))
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extension UserStoreData {

    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch  {
            fatalError("Couldn't save data")
        }
    }
    
    func deleteAccount() {
        if account != nil {
            managedObjectContext.delete(account!)
        } else {
            dspAlert.showAlert(message: "Can't delete account!")
        }
    }
    
}



