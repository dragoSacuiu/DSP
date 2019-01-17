//
//  ReciversManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

final class ReciversManager {
    weak var delegate: ReciversManagerVCDelegate?
    
    var accountsEvents = [AccountEvents]()
    var accountsDetailes = [String:AccountEntity]()

    var runDispatchTimer: Timer?
    var storeData = StoreData()
    var iprsReciver = Iprs()
    
    func run(dipatchTimeInterval: Double) {
        runDispatchTimer = Timer.scheduledTimer(timeInterval: dipatchTimeInterval , target: self, selector: #selector(getEvents), userInfo: nil, repeats: true)
    }
    func stop() {
        runDispatchTimer!.invalidate()
    }
    
    @objc func getEvents(){
        var events = [AccountEvents]()
        events.append(contentsOf: iprsReciver.getEvents())
        
        if events.count > 0 {
            filterEvents(events: events)
            delegate!.reloadTableViewData()
        }
    }
}

extension ReciversManager {
    
    func filterEvents(events: [AccountEvents]) {
        let newAccountEvents = events
        if accountsEvents.count == 0 {
            accountsEvents.append(contentsOf: newAccountEvents)
            for newAccount in newAccountEvents {
                let accountDetailes = storeData.getAccountMO(accountId: newAccount.id)
                accountsDetailes[newAccount.id] = accountDetailes
            }
        } else {
            for newAccount in newAccountEvents {
                var matchAccount = false
                for accountIndex in 0..<accountsEvents.count {
                    if accountsEvents[accountIndex].id == newAccount.id {
                        accountsEvents[accountIndex].events.append(contentsOf: newAccount.events)
                        matchAccount = true
                        break
                    }
                }
                if !matchAccount {
                    accountsEvents.append(newAccount)
                    let accountDetailes = storeData.getAccountMO(accountId: newAccount.id)
                    accountsDetailes[newAccount.id] = accountDetailes
                }
            }
        }
    }
    
    
    
    
}
