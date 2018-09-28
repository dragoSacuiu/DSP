//
//  TehnicalInfoMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension TehnicalInfoMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TehnicalInfoMO> {
        return NSFetchRequest<TehnicalInfoMO>(entityName: "TehnicalInfoMO")
    }

    @NSManaged public var periodicTest: String?
    @NSManaged public var reciver: String?
    @NSManaged public var system: String?
    @NSManaged public var tehnicalTeam: String?
    @NSManaged public var conectionDate: String?
    @NSManaged public var objective: ObjectiveMO?

}
