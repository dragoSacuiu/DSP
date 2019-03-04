//
//  File.swift
//  DSP
//
//  Created by Sacuiu Dragos on 26/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Foundation
import CoreData

class StoreUsers {
    let dspAlert = DspAlert()
    let managedObjectContext = CoreDataManager(dataModelName: "DSP").managedObjectContext
    
    let nameSortDescirptor = NSSortDescriptor(key: "name", ascending: true)
    
    func storeUser(name: String, password: String) {
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: managedObjectContext) as! UserEntity
        newUser.name = name
        newUser.password = password
    }
    
    func storeManager(name: String, email: String) {
        let newManager = NSEntityDescription.insertNewObject(forEntityName: "ManagerEntity", into: managedObjectContext) as! ManagerEntity
        newManager.name = name
        newManager.email = email
        save()
    }
    
    func getUsers() -> [UserEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        fetchRequest.sortDescriptors = [nameSortDescirptor]
        do {
            return try managedObjectContext.fetch(fetchRequest) as! [UserEntity]
        } catch {
            dspAlert.showAlert(message: "Can't get users list from database")
        }
        return []
    }
    
    func getManagers() -> [ManagerEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagerEntity")
        fetchRequest.sortDescriptors = [nameSortDescirptor]
        do {
            return try managedObjectContext.fetch(fetchRequest) as! [ManagerEntity]
        } catch  {
            dspAlert.showAlert(message: "Can't get managers list from database")
        }
        return []
    }
    
    func getUser(selectedUserIndex: Int) -> UserEntity {
        return getUsers()[selectedUserIndex]
    }
    func getManager(selectedManagerIndex: Int) -> ManagerEntity {
        return getManagers()[selectedManagerIndex]
    }
    func removeUser(selectedUserIndex: Int) {
        let user = getUsers()[selectedUserIndex]
        managedObjectContext.delete(user)
    }
    func removeManager(selectedManagerIndex: Int) {
        let manager = getManagers()[selectedManagerIndex]
        managedObjectContext.delete(manager)
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            dspAlert.showAlert(message: "Can't save data")
        }
    }
}
