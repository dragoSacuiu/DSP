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

class StoreData {
    let dspAlert = DspAlert()
    let managedObjectContext = CoreDataManager(dataModelName: "DSP").managedObjectContext
    
    let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    let numberSortDescriptor = NSSortDescriptor(key: "number", ascending: true)
    
    var account: AccountEntity?
    
    func createNewAccount() {
        account = (NSEntityDescription.insertNewObject(forEntityName: "AccountEntity", into: managedObjectContext) as! AccountEntity)
        createNewSchedule()
    }
    
    func createExistingAccount(accountID: String) {
        account = getAccount(accountId: accountID)!
    }
    
////////////////////////////////// STORE DATA ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func storeAccoutEvents(accoutsEvents: [AccountEvents]) {
        for accountEvents in accoutsEvents {
            let fetchAccount = getAccount(accountId: accountEvents.id)
            guard fetchAccount == nil else {
                if fetchAccount!.id == accountEvents.id {
                    for event in accountEvents.events {
                        let eventEntity = EventEntity(context: managedObjectContext)
                        eventEntity.date = event.date
                        eventEntity.eventName = event.name
                        eventEntity.cid = event.cid
                        eventEntity.group = event.group
                        eventEntity.partition = event.partition
                        eventEntity.zoneOrUser = event.zoneOrUser
                        eventEntity.priority = Int16(event.priority)
                        fetchAccount!.addToEvents(eventEntity)
                    }
                }
                return
            }
        }
    }
    
    func createNewSchedule() {
        account!.schedeule = (NSEntityDescription.insertNewObject(forEntityName: "ScheduleEntity", into: managedObjectContext) as! ScheduleEntity)
        account!.schedeule!.monday = String()
        account!.schedeule!.tuesday = String()
        account!.schedeule!.wednesday = String()
        account!.schedeule!.thursday = String()
        account!.schedeule!.friday = String()
        account!.schedeule!.saturday = String()
        account!.schedeule!.sunday = String()
    }
    
    func storeSchedule(day: String, startTime: String, endTime: String) {
        switch day {
        case "MONDAY": account!.schedeule!.monday = "\(startTime) \(endTime)"
        case "TUESDAY": account!.schedeule!.tuesday = "\(startTime) \(endTime)"
        case "WEDNESDAY": account!.schedeule!.wednesday = "\(startTime) \(endTime)"
        case "THURSDAY": account!.schedeule!.thursday = "\(startTime) \(endTime)"
        case "FRIDAY": account!.schedeule!.friday = "\(startTime) \(endTime)"
        case "SATURDAY": account!.schedeule!.saturday = "\(startTime) \(endTime)"
        case "SUNDAY":account!.schedeule!.sunday = "\(startTime) \(endTime)"
        default:
            dspAlert.showAlert(message: "")
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
        let partitions = account!.partitions!.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
        for partition in partitions {
            let zones = partition.zones!.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity]
            for zone in zones {
                if zone.number == newZoneNumber {
                    zoneExists = true
                    dspAlert.showAlert(message: "Zone number already exists!")
                    break
                }
            }
        }
        guard zoneExists else {
            let newZone = NSEntityDescription.insertNewObject(forEntityName: "ZoneEntity", into: managedObjectContext) as! ZoneEntity
            newZone.number = Int16(newZoneNumber)
            newZone.name = newZoneName
            partitions[partitionNumber].addToZones(newZone)
            return
        }
    }
    
    func storeContact(priority: Int, name: String, userNumber: Int, phoneNumber: String, email: String, observations: String) {
        let newContact = ContactEntity(context: managedObjectContext)
        newContact.priority = Int16(priority)
        newContact.name = name
        newContact.userNumber = Int16(userNumber)
        newContact.phoneNumber = phoneNumber
        newContact.email = email
        newContact.observations = observations
        account!.contacts?.adding(newContact)
    }
    
    func storeEmiDetail(emiDetail: String) {
        let newEmiDetail = EmiDetailesEntity(context: managedObjectContext)
        newEmiDetail.date = NSDate()
        newEmiDetail.user = UsersManager.activeUser
        newEmiDetail.detailes = emiDetail
        account!.emiDetails?.adding(newEmiDetail)
    }
    
    func storeObservation(observation: String) {
        let newObservation = ObservationsEntity(context: managedObjectContext)
        newObservation.date = NSDate()
        newObservation.user = UsersManager.activeUser
        newObservation.observation = observation
        account!.observations?.adding(newObservation)
    }
    
    func storeTicket(ticketType: String, manager: String, ticketContent: String) {
        let newTicket = TicketEntity(context: managedObjectContext)
        newTicket.date = NSDate()
        newTicket.user = UsersManager.activeUser
        newTicket.number = getTicketNumber()
        newTicket.manager = manager
        newTicket.status = "OPEN"
        newTicket.type = ticketType
        newTicket.content = ticketContent
        account!.tickets?.adding(newTicket)
    }
}

///////////////////////////// GET DATA  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension StoreData {
    
    func getAccount(accountId: String) -> AccountEntity? {
        let fetchDescription = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountEntity")
        do {
            let fetchResult = try managedObjectContext.fetch(fetchDescription) as! [AccountEntity]
            for accountEntity in fetchResult {
                if accountEntity.id == accountId {
                    return accountEntity
                }
            }
        } catch  {
            print("Account dose not exists in database")
        }
        return nil
    }
    
    func getTicketNumber() -> String {
        let fetchDescription = NSFetchRequest<NSFetchRequestResult>(entityName: "TicketNumberEntity")
        do {
            let fetchResult = try managedObjectContext.fetch(fetchDescription) as! [TicketNumberEntity]
            if fetchResult.count == 0 {
                let firstTicketNumber = TicketNumberEntity(context: managedObjectContext)
                firstTicketNumber.number = 100000
            } else {
                return String(fetchResult[0].number + 1)
            }
        } catch {
            dspAlert.showAlert(message: "Cannot get ticket number from database")
        }
        return "????????"
    }

    func getPartition(partitionNumber: Int) -> PartitionEntity {
        let partitions = getPartitions()
        for partition in partitions {
            if partition.number == partitionNumber {
                return partition
            }
        }
        return PartitionEntity()
    }
    
    func getPartitions() -> [PartitionEntity] {
        return account!.partitions!.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
    }
    
    func getZone(partitionNumber: Int, zoneNumber: Int) -> ZoneEntity {
        let zones = getZones(partitionNumber: partitionNumber)
        for zone in zones {
            if zone.number == zoneNumber{
                return zone
            }
        }
        return ZoneEntity()
    }
    
    func getZones(partitionNumber: Int) -> [ZoneEntity] {
        let partition = getPartition(partitionNumber: partitionNumber)
        let zones = partition.zones!.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity]
        return zones
    }
    
    func getContacts() -> [ContactEntity] {
        var contacts = [ContactEntity]()
        for contactItem in account!.contacts!.sortedArray(using: [dateSortDescriptor]) {
            let contact = contactItem as! ContactEntity
            contacts.append(contact)
        }
        return contacts
    }
    
    func getEmiDetail(date: Date) -> EmiDetailesEntity {
        for item in account!.emiDetails! {
            let fetchEmiDetail = item as! EmiDetailesEntity
            if fetchEmiDetail.date! as Date == date {
                return fetchEmiDetail
            }
        }
        return EmiDetailesEntity()
    }
    
    func getEmiDetailes() -> [EmiDetailesEntity] {
        return account!.emiDetails!.sortedArray(using: [dateSortDescriptor]) as! [EmiDetailesEntity]
    }
    
}
///////////////////////////// GLOBAL FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
extension StoreData {
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch  {
            fatalError("Couldn't save data")
        }
    }
    
    func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }
    
}



