//
//  IPRS-7.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation



class Iprs: ReciversProtocol {
    var iprsCSVLogFilesPath = "/Volumes/home/backup/iprs/201804"
    var textFilesTools = FilesTools()
    let eventsManager = EventsManager()
    
    func getEvents() -> [AccountEvents] {
        var events = [AccountEvents]()
        events.append(contentsOf: getEventsFromLogFiles())
        return events
    }
}

extension Iprs {
    
    func getEventsFromLogFiles() -> [AccountEvents] {
        let filesText = textFilesTools.getTextFromFile(from: iprsCSVLogFilesPath, fileType: "csv")
        var accountEvents = [AccountEvents]()
        for file in filesText {
            let fileName = file.FileName
            let accountID = textFilesTools.cutFromTextLine(TextLine: fileName, From: 8, To: 11)
            var account = AccountEvents(id: accountID)
            for textLine in file.Content {
                if textLine != "" {
                    let splitTextEvent = textLine.components(separatedBy: ",")
                    let cid = splitTextEvent[2].components(separatedBy: " ")
                    let event = Event(date: splitTextEvent[1], cid: cid[0], eventName: splitTextEvent[5], eventType: eventsManager.getEventType(eventCode: splitTextEvent[0]), partition: splitTextEvent[3], zoneOrUser: splitTextEvent[4], group: cid[1], mac: splitTextEvent[6])
                    account.events.append(event)
                }
            }
            accountEvents.append(account)
        }
        return accountEvents
    }
}
