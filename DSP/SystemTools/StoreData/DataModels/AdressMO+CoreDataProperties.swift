//
//  AdressMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension AdressMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdressMO> {
        return NSFetchRequest<AdressMO>(entityName: "AdressMO")
    }

    @NSManaged public var county: String?
    @NSManaged public var city: String?
    @NSManaged public var street: String?
    @NSManaged public var streetNr: String?
    @NSManaged public var buildingNr: String?
    @NSManaged public var flor: String?
    @NSManaged public var appartment: String?
    @NSManaged public var long: String?
    @NSManaged public var lat: String?
    @NSManaged public var objective: ObjectiveMO?

}
