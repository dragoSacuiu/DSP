//
//  ReciversManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

class ReciversManager {
    

    
    var iprsReciver = Iprs()
    
    func getEvents() -> [AccountEvents] {
        var events = [AccountEvents]()
        events.append(contentsOf: iprsReciver.getEvents())
        
        return events
    }
}
