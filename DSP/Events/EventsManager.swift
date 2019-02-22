//
//  File.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation
import Cocoa

class EventsManager {
   
    weak var delegate: EventsManagerVCDelegate?
    
    var reciversManager = ReciversManager()
    var storeData = StoreData()
    
    var runDispatchTimer: Timer?
    
    var accountsEvents = [AccountEvents]()
    
    let redColor = NSColor.systemRed.cgColor
    let blueColor = NSColor.systemBlue.cgColor
    let greenColor = NSColor.systemGreen.cgColor
    let orangeColor = NSColor.systemOrange.cgColor
    let grayColor = NSColor.lightGray.cgColor
    let whiteColor = NSColor.white.cgColor
    
    let eventRestoreColor = NSColor.white.cgColor
    let systemDisarmColor = NSColor.systemYellow.cgColor
    
    let medicalAlarmImage = NSImage(named: "MedicalAlarm")!
    let panicAlarmImage = NSImage(named: "PanicImage")!
    let burglarAlarmImage = NSImage(named: "BurglarAlarmImage")!
    let fireAlarmImage = NSImage(named: "FireAlarmImage")!
    let generalAlarmImage = NSImage(named: "GeneralAlarm")!
    let troubleImage = NSImage(named: "TroubleImage")!
    let openCloseImage = NSImage(named: "OpenCloseImage")!
    let unknownImage = NSImage(named: "UnknownImage")!
    
    
    
    func run(getEventsTimeInterval: Double) {
        runDispatchTimer = Timer.scheduledTimer(timeInterval: getEventsTimeInterval , target: self, selector: #selector(getEvents), userInfo: nil, repeats: true)
    }
    func stop() {
        runDispatchTimer!.invalidate()
    }
    
    @objc func getEvents() {
        deleteLowPriorityEvents()
        let events = reciversManager.getEventsFromRecivers()
        if events.count > 0 {
            filterEvents(events: events)
        }
        delegate?.reloadTableViewData()
    }
    
    func filterEvents(events: [AccountEvents]) {
        let newAccountEvents = events
        if accountsEvents.count == 0 {
            for account in newAccountEvents {
                account.priorityEvent = getPriorityEvent(events: account.events)
                account.priorityEventType = getEventType(event: account.priorityEvent!)
                let accountModel = storeData.getAccount(accountId: account.id)
                account.accountDetailes = accountModel
                accountsEvents.append(account)
            }
        } else {
            for accountIndex in 0..<accountsEvents.count {
                var matchAccount = false
                let account = accountsEvents[accountIndex]
                for newAccount in newAccountEvents {
                    if account.id == newAccount.id {
                        let newAccountPriorityEvent = getPriorityEvent(events: newAccount.events)
                        if newAccountPriorityEvent.priority < account.priorityEvent!.priority {
                            let newAccountEventType = getEventType(event: newAccountPriorityEvent)
                            account.priorityEvent = newAccountPriorityEvent
                            account.priorityEventType = newAccountEventType
                        }
                        accountsEvents[accountIndex].events.append(contentsOf: newAccount.events)
                        matchAccount = true
                        break
                    }
                    if !matchAccount {
                        newAccount.priorityEvent = getPriorityEvent(events: newAccount.events)
                        newAccount.priorityEventType = getEventType(event: newAccount.priorityEvent!)
                        let accountModel = storeData.getAccount(accountId: newAccount.id)
                        newAccount.accountDetailes = accountModel
                        accountsEvents.append(newAccount)
                    }
                }
            }
        }
    }
    
}


extension EventsManager {
    
    func deleteLowPriorityEvents() {
        if accountsEvents.count > 0 {
            for accountIndex in 0..<accountsEvents.count {
                if accountsEvents[accountIndex].priorityEvent!.priority > 6 {
                    accountsEvents.remove(at: accountIndex)
                }
            }
        }
    }
    
    func getPriorityEvent(events: [Event]) -> Event {
        var sortedEvents = events.sorted(by: {$0.priority < $1.priority })
        return sortedEvents[0]
    }
    
    func getEventType(event: Event) -> EventType {
    
        switch event.priority {
            
        case 1: let medicalAlarmEventType = EventType(name: "MEDICAL ALARM", color: redColor, image: medicalAlarmImage)
            if event.group == "3" {
                medicalAlarmEventType.color = eventRestoreColor
            }
            return medicalAlarmEventType
            
        case 2: let fireAlarmEventType = EventType(name: "FIRE ALARM", color: redColor, image: fireAlarmImage)
            if event.group == "3" {
                fireAlarmEventType.color = eventRestoreColor
            }
            return fireAlarmEventType
            
        case 3: let panicAlarmEventType = EventType(name: "PANIC ALARM", color: redColor, image: panicAlarmImage)
            if event.group == "3" {
                panicAlarmEventType.color = eventRestoreColor
            }
            return panicAlarmEventType
            
        case 4: let burglarAlarmType = EventType(name: "BURGLAR ALARM", color: redColor, image: burglarAlarmImage)
            if event.group == "3" {
                burglarAlarmType.color = eventRestoreColor
            }
            return burglarAlarmType
            
        case 5: let generalAlarmEventType = EventType(name: "GENERAL ALARM", color: redColor, image: generalAlarmImage)
            if event.group == "3" {
                generalAlarmEventType.color = eventRestoreColor
            }
            return generalAlarmEventType
            
        case 6: let troubleEventType = EventType(name: "TROUBLE", color: blueColor, image: troubleImage)
            if event.group == "3" {
                troubleEventType.color = eventRestoreColor
            }
            return troubleEventType
            
        case 7: let openCloseEventType = EventType(name: "OPEN CLOSE", color: greenColor, image: openCloseImage)
            if event.group == "1" {
                openCloseEventType.color = systemDisarmColor
            }
            return openCloseEventType
            
        case 8: let testEventType = EventType(name: "TEST", color: grayColor, image: unknownImage)
            if event.group == "3" {
                testEventType.color = eventRestoreColor
            }
            return testEventType
            
        case 9: let fireSupervisoryEventType = EventType(name: "FIRE SUPERVISORY", color: blueColor, image: unknownImage)
            if event.group == "3" {
                fireSupervisoryEventType.color = eventRestoreColor
            }
            return fireSupervisoryEventType
            
        case 10: let protectionLoopEventType = EventType(name: "PROTECTION LOOP", color: blueColor, image: unknownImage)
            if event.group == "3" {
                protectionLoopEventType.color = eventRestoreColor
            }
            return protectionLoopEventType
            
        case 11: let sensorEvetType = EventType(name: "SENSOR", color: blueColor, image: unknownImage)
            if event.group == "3" {
                sensorEvetType.color = eventRestoreColor
            }
            return sensorEvetType
            
        case 12: let systemAccesEventType = EventType(name: "SYSTEMACCES", color: orangeColor, image: unknownImage)
            if event.group == "3" {
                systemAccesEventType.color = eventRestoreColor
            }
            return systemAccesEventType
            
        case 13: let disableEventType = EventType(name: "DISABLES", color:orangeColor, image: unknownImage)
            if event.group == "1" {
                disableEventType.color = eventRestoreColor
            }
            return disableEventType
            
        case 14: let bypassEventType = EventType(name: "BYPAS", color: orangeColor, image: unknownImage)
            if event.group == "3" {
                bypassEventType.color = eventRestoreColor
            }
            return bypassEventType
            
        case 15: let eventLogEventType = EventType(name: "EVENT LOG", color: grayColor, image: unknownImage)
            if event.group == "3" {
                eventLogEventType.color = eventRestoreColor
            }
            return eventLogEventType
            
        case 16: let scheduleEventType = EventType(name: "SCHEDULE", color: whiteColor, image: unknownImage)
            if event.group == "3" {
                scheduleEventType.color = eventRestoreColor
            }
            return scheduleEventType
            
        case 17: let miscelaneousEventType = EventType(name: "MISCELANEOUS", color: whiteColor, image: unknownImage)
            if event.group == "3" {
                miscelaneousEventType.color = eventRestoreColor
            }
            return miscelaneousEventType
            
        default:
            return EventType(name: "UNKNOWN EVENT", color: whiteColor, image: unknownImage)
        }
    }
}
