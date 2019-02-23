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
                let firstTicketNumber = NSEntityDescription.insertNewObject(forEntityName: "TicketNumber", into: managedObjectContext) as! TicketNumberEntity
                firstTicketNumber.number = 100000
            } else {
                return String(fetchResult[0].number + 1)
            }
        } catch {
            dspAlert.showAlert(message: "Cannot get ticket number from database")
        }
        return "????????"
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
    
    func getObservation(selectedObservation: Int) -> String {
        let observations = account?.observations?.sortedArray(using: [dateSortDescriptor]) as! [ObservationsEntity]
        return observations[selectedObservation].observation!
    }
    
    func getEmiDetail(selectedEmiDetail: Int) -> String {
        let emiDetails = account?.emiDetails?.sortedArray(using: [dateSortDescriptor]) as! [EmiDetailesEntity]
        return emiDetails[selectedEmiDetail].detailes!
    }
    
    func getContact(selectedContact: Int) -> ContactEntity {
        let contacts = account?.contacts?.sortedArray(using: [dateSortDescriptor]) as! [ContactEntity]
        return contacts[selectedContact]
    }
    
    func getTicket(selectedTicket: Int) -> TicketEntity {
        let tickets = account?.tickets?.sortedArray(using: [dateSortDescriptor]) as! [TicketEntity]
        return tickets[selectedTicket]
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



