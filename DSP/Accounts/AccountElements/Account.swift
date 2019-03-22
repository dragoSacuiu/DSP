//
//  AccountElemets.swift
//  DSP
//
//  Created by Sacuiu Dragos on 11/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Foundation

class AccountEvents {
    var id: String
    var events: [Event]
    var priorityEvent: Event?
    var priorityEventType: EventType?
    var details: AccountEntity?
    var generatedAlarm = false
    var emi: EmiEntity?
    
    init(id: String) {
        self.id = id
        self.events = [Event]()
    }
}
