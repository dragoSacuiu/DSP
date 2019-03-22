//
//  ReciversManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

protocol ReciverProtocol {
    func getEvents() -> [AccountEvents]
}

class ReciversManager: IprsReciverDelegate {
    var blackList = [String]()

    var iprsReciver = Iprs()
    init() {
        iprsReciver.delegate = self
    }

    func getEventsFromRecivers() -> [AccountEvents] {
        
        var events = [AccountEvents]()
        
        let iprsReciverEvents = iprsReciver.getEvents()
        events.append(contentsOf: iprsReciverEvents)
        
        return events
    }
    
    func removeFromBlackList(accountID: String) {
        for index in 0..<blackList.count {
            if accountID == blackList[index] {
                blackList.remove(at: index)
                break
            }
        }
    }
    
}

