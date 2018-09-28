//
//  File.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

struct AccountEvents {
    var id: String
    var events: [Event]
    
    init(id: String) {
        self.id = id
        self.events = [Event]()
    }
    
    mutating func changeAccountId (newAccountId: String) {
        self.id = newAccountId
    }
    
    mutating func addEvents (newEvents: [Event]) {
        self.events.append(contentsOf: newEvents)
    }
}
