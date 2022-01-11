//
//  StorageManager.swift
//  C2 HomeWork 14
//
//  Created by Вадим on 30.10.2020.
//  Copyright © 2020 Vadim. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func addTask(_ task: Task) {
        try! realm.write {
            realm.add(task)
        }
    }
    
    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func rename(_ task: Task, with newValue: String) {
        try! realm.write {
            task.name = newValue
        }
    }
    
}
