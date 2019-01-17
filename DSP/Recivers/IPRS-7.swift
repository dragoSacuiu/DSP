//
//  IPRS-7.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

class Iprs: ReciverProtocol {
    var iprsCSVLogFilesPath = "/Volumes/home/iprs/201901"
    var textFilesTools = FilesTools()
    let eventsManager = EventsManager()
    
    func getEvents() -> [AccountEvents] {
        var events = [AccountEvents]()
        events.append(contentsOf: createEventsFromIPRSLogFiles())
        return events
    }
}

extension Iprs {
    
    func createEventsFromIPRSLogFiles() -> [AccountEvents] {
        var accountEvents = [AccountEvents]()
        let filesText = textFilesTools.getTextFromFile(from: iprsCSVLogFilesPath, fileType: "csv")
        if filesText.count > 0 {
            for file in filesText {
                let fileName = file.FileName
                let accountID = textFilesTools.cutFromTextLine(TextLine: fileName, From: 8, To: 12)
                var account = AccountEvents(id: accountID)
                let textLines = file.Content.components(separatedBy: "\n")
                for textLine in textLines {
                    if textLine != "" {
                        let splitTextEvent = textLine.components(separatedBy: ",")
                        let eventName = textFilesTools.replaceCharInString(string: splitTextEvent[5], charToBeReplaced: "\"", with: "")
                        let cidAndGroup = splitTextEvent[2].components(separatedBy: " ")
                        let cid = cidAndGroup[1]
                        let group = cidAndGroup[0]
                        let typeAndPriority = eventsManager.getEventTypeAndPriority(event: )
                        let event = Event(priority: typeAndPriority.1, date: splitTextEvent[1], cid: cid, eventName: eventName.uppercased(), type: typeAndPriority.0, partition: splitTextEvent[3], zoneOrUser: splitTextEvent[4], group: group)
                        account.events.append(event)
                    }
                }
                if account.events.count > 0 {
                    accountEvents.append(account)
                }
            }
        }
        return accountEvents
    }
}








