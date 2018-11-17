//
//  IPRS-7.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation



class Iprs: ReciverProtocol {
    var iprsCSVLogFilesPath = "smb://vdrs-pc/Users/Public/iprs/201811"
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
                        let cid = splitTextEvent[2].components(separatedBy: " ")
                        let event = IprsEvent(date: splitTextEvent[1], cid: cid[1], eventName: eventName.uppercased(), eventType: eventsManager.getEventType(eventCode: Int(cid[1])!), partition: splitTextEvent[3], zoneOrUser: splitTextEvent[4], group: cid[0], mac: splitTextEvent[6])
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








