//
//  DateAndTime.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

func stringToDate(StringDate: String) -> Date {
    let dateFormater = DateFormatter()
    dateFormater.dateStyle = .short
    dateFormater.timeZone = TimeZone.current
    dateFormater.locale = Locale.current
    let date = dateFormater.date(from: StringDate)
    return date!
}

func run(TimeInterval: TimeInterval, Target: Any, Selector: Selector, Repeat: Bool ) {
    let _ = Timer.scheduledTimer(timeInterval: TimeInterval, target: Target, selector: Selector, userInfo: nil, repeats: Repeat)
}
