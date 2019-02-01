//
//  ReciversManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

final class ReciversManager {

    var iprsReciver = Iprs()

        func getEventsFromRecivers() -> [AccountEvents] {
        var events = [AccountEvents]()
            
        let iprsReciverEvents = iprsReciver.getEvents()
        
        events.append(contentsOf: iprsReciverEvents)

        return events
    }
}

