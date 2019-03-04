//
//  UserEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 26/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?

}
