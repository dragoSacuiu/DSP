//
//  File.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation
import Cocoa

protocol DspVCDelegate: class {
    func reloadTableViewData()
    func generateAlert()
}

class DspManager: AddAcccountVCDelegate {
    
    var dspVCDelegate: DspVCDelegate?
    
    private var reciversManager = ReciversManager()
    var storeData = DspStoreData()
    
    private var runDispatchTimer: Timer?
    
    var accountsEvents = [AccountEvents]()
    var serviceModeAccounts = [AccountEvents]()
    
    private let redColor = NSColor.systemRed.cgColor
    private let blueColor = NSColor.systemBlue.cgColor
    private let greenColor = NSColor.systemGreen.cgColor
    private let orangeColor = NSColor.systemOrange.cgColor
    private let grayColor = NSColor.lightGray.cgColor
    private let whiteColor = NSColor.white.cgColor
    
    private  let eventRestoreColor = NSColor.white.cgColor
    private let systemDisarmColor = NSColor.systemYellow.cgColor
    
    private let medicalAlarmImage = NSImage(named: "MedicalAlarm")!
    private let panicAlarmImage = NSImage(named: "PanicImage")!
    private let burglarAlarmImage = NSImage(named: "BurglarAlarmImage")!
    private let fireAlarmImage = NSImage(named: "FireAlarmImage")!
    private let generalAlarmImage = NSImage(named: "GeneralAlarm")!
    private let troubleImage = NSImage(named: "TroubleImage")!
    private let openCloseImage = NSImage(named: "OpenCloseImage")!
    private let unknownImage = NSImage(named: "UnknownImage")!
    
    func run(getEventsTimeInterval: Double) {
        reciversManager.blackList = storeData.getBlackList()
        runDispatchTimer = Timer.scheduledTimer(timeInterval: getEventsTimeInterval , target: self, selector: #selector(getEvents), userInfo: nil, repeats: true)
    }
    func stop() {
        guard runDispatchTimer == nil else {
            runDispatchTimer!.invalidate()
            return
        }
    }
    
    @objc func getEvents() {
        ///deleteLowPriorityEvents()
        let newAccountsEvents = reciversManager.getEventsFromRecivers()
        if newAccountsEvents.count > 0 {
            for newAccount in newAccountsEvents {
                if let accountEvents = filterEvents(account: newAccount) {
                    if !serviceModeAccounts.contains(where: {$0.id == newAccount.id}) {
                        accountsEvents.append(accountEvents)
                    }
                }
            }
            dspVCDelegate?.generateAlert()
        }
    }
    
    private func filterEvents(account: AccountEvents) -> AccountEvents? {
        var matchAccount = false
        if accountsEvents.count == 0 && serviceModeAccounts.count == 0 { return addNewAccount(newAccount: account) }
        if addExistingAccount(accountsEvents: serviceModeAccounts, newAccount: account) ||
        addExistingAccount(accountsEvents: accountsEvents, newAccount: account) { matchAccount = true }
        if !matchAccount { return addNewAccount(newAccount: account) }
        return nil
    }
    
    private func addExistingAccount(accountsEvents: [AccountEvents], newAccount: AccountEvents) -> Bool {
        for account in accountsEvents {
            if account.id == newAccount.id {
                let accountNewPriorityEvent = getPriorityEvent(events: newAccount.events)
                if accountNewPriorityEvent.priority < account.priorityEvent!.priority {
                    let newAccountEventType = getEventType(event: accountNewPriorityEvent)
                    account.priorityEvent = accountNewPriorityEvent
                    account.priorityEventType = newAccountEventType
                    account.generatedAlarm = false
                }
                account.events.append(contentsOf: newAccount.events)
                return true
            }
        }
        return false
    }
    
    private func addNewAccount(newAccount: AccountEvents) -> AccountEvents? {
        if let accountModel = storeData.getAccount(accountId: newAccount.id) {
            newAccount.priorityEvent = getPriorityEvent(events: newAccount.events)
            newAccount.priorityEventType = getEventType(event: newAccount.priorityEvent!)
            newAccount.details = accountModel
            return newAccount
        } else {
            reciversManager.blackList.append(newAccount.id)
            storeData.addUndefinedAccountToBlackList(accountID: newAccount.id)
        }
        return nil
    }

    func reloadTableViewsData() {
        dspVCDelegate?.reloadTableViewData()
    }
    
}

extension DspManager {
    
    func getEmis() -> [EmiEntity] {
        return storeData.getEmis()!
    }
    
    func removeFromServiceMode(index: Int) {
        if serviceModeAccounts.count > 0 {
            serviceModeAccounts[index].generatedAlarm = false
            accountsEvents.append(serviceModeAccounts[index])
            serviceModeAccounts.remove(at: index)
        }
    }
    
    func addToServiceMode(index: Int) {
        serviceModeAccounts.append(accountsEvents[index])
    }

    func addToBlackList(accountID: String) {
        reciversManager.blackList.append(accountID)
    }
    
    func removeFromBlackList(accountID: String) {
        storeData.removeAccountIDFromBlackList(accountID: accountID)
        reciversManager.removeFromBlackList(accountID: accountID)
    }

    private func deleteLowPriorityEvents() {
        if accountsEvents.count > 0 {
            for accountIndex in 0..<accountsEvents.count {
                if accountsEvents[accountIndex].priorityEvent!.priority > 6 {
                    accountsEvents.remove(at: accountIndex)
                }
            }
        }
    }
    
    private func getPriorityEvent(events: [Event]) -> Event {
        var sortedEvents = events.sorted(by: {$0.priority < $1.priority })
        return sortedEvents[0]
    }
    
    func getEventType(event: Event) -> EventType {
        switch event.priority {
            
        case 1: let medicalAlarmEventType = EventType(name: "MEDICAL ALARM", color: redColor, image: medicalAlarmImage)
        if event.group == 3 { medicalAlarmEventType.color = eventRestoreColor }
        return medicalAlarmEventType
            
        case 2: let fireAlarmEventType = EventType(name: "FIRE ALARM", color: redColor, image: fireAlarmImage)
        if event.group == 3 { fireAlarmEventType.color = eventRestoreColor }
        return fireAlarmEventType
            
        case 3: let panicAlarmEventType = EventType(name: "PANIC ALARM", color: redColor, image: panicAlarmImage)
        if event.group == 3 { panicAlarmEventType.color = eventRestoreColor }
        return panicAlarmEventType
            
        case 4: let burglarAlarmType = EventType(name: "BURGLAR ALARM", color: redColor, image: burglarAlarmImage)
        if event.group == 3 { burglarAlarmType.color = eventRestoreColor }
        return burglarAlarmType
            
        case 5: let generalAlarmEventType = EventType(name: "GENERAL ALARM", color: redColor, image: generalAlarmImage)
        if event.group == 3 { generalAlarmEventType.color = eventRestoreColor }
        return generalAlarmEventType
            
        case 6: let troubleEventType = EventType(name: "TROUBLE", color: blueColor, image: troubleImage)
        if event.group == 3 { troubleEventType.color = eventRestoreColor }
        return troubleEventType
            
        case 7: let openCloseEventType = EventType(name: "OPEN CLOSE", color: greenColor, image: openCloseImage)
        if event.group == 1 { openCloseEventType.color = systemDisarmColor }
        return openCloseEventType
            
        case 8: let testEventType = EventType(name: "TEST", color: grayColor, image: unknownImage)
        if event.group == 3 { testEventType.color = eventRestoreColor }
        return testEventType
            
        case 9: let fireSupervisoryEventType = EventType(name: "FIRE SUPERVISORY", color: blueColor, image: unknownImage)
        if event.group == 3 { fireSupervisoryEventType.color = eventRestoreColor }
        return fireSupervisoryEventType
            
        case 10: let protectionLoopEventType = EventType(name: "PROTECTION LOOP", color: blueColor, image: unknownImage)
        if event.group == 3 { protectionLoopEventType.color = eventRestoreColor }
        return protectionLoopEventType
            
        case 11: let sensorEvetType = EventType(name: "SENSOR", color: blueColor, image: unknownImage)
        if event.group == 3 { sensorEvetType.color = eventRestoreColor }
        return sensorEvetType
            
        case 12: let systemAccesEventType = EventType(name: "SYSTEMACCES", color: orangeColor, image: unknownImage)
        if event.group == 3 { systemAccesEventType.color = eventRestoreColor }
        return systemAccesEventType
            
        case 13: let disableEventType = EventType(name: "DISABLES", color:orangeColor, image: unknownImage)
        if event.group == 1 { disableEventType.color = eventRestoreColor }
        return disableEventType
            
        case 14: let bypassEventType = EventType(name: "BYPAS", color: orangeColor, image: unknownImage)
        if event.group == 3 { bypassEventType.color = eventRestoreColor }
        return bypassEventType
            
        case 15: let eventLogEventType = EventType(name: "EVENT LOG", color: grayColor, image: unknownImage)
        if event.group == 3 { eventLogEventType.color = eventRestoreColor }
        return eventLogEventType
            
        case 16: let scheduleEventType = EventType(name: "SCHEDULE", color: whiteColor, image: unknownImage)
        if event.group == 3 { scheduleEventType.color = eventRestoreColor }
        return scheduleEventType
            
        case 17: let miscelaneousEventType = EventType(name: "MISCELANEOUS", color: whiteColor, image: unknownImage)
        if event.group == 3 { miscelaneousEventType.color = eventRestoreColor }
        return miscelaneousEventType
            
        default: return EventType(name: "UNKNOWN EVENT", color: whiteColor, image: unknownImage)
        }
    }
}
