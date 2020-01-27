//
//  Storage.swift
//  Core
//
//  Created by Dima Virych on 27.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

protocol Storage {
    
    associatedtype Object
    associatedtype List
    associatedtype Results
    associatedtype Value
    
    func add(_ object: Object)
    
    func addArray(_ array: [Object])
    
    func addArray(array: List)
    
    func change(_ changesBlock: @escaping () -> Void)
    
    func delete(_ object: Object)
    
    func deleteObjects(_ objects: List)
    
    func deleteObjects(_ objects: Results)
    
    func objects(_ type: Object.Type) -> Results
    
    func objectsForKey(_ type: Object.Type, key: String, value: Value) -> Results
    
    func objectsForKeys(_ type: Object.Type, key: String, value: Value) -> Results
    
    func objectForPrimaryKey(key: String, value: Value) -> Object?
}
