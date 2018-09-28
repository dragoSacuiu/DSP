//
//  ObjectiveInfoMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ObjectiveInfoMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObjectiveInfoMO> {
        return NSFetchRequest<ObjectiveInfoMO>(entityName: "ObjectiveInfoMO")
    }

    @NSManaged public var date: String?
    @NSManaged public var info: String?
    @NSManaged public var user: String?
    @NSManaged public var objective: ObjectiveMO?

}
