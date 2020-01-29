//
//  Store.swift
//  Core
//
//  Created by Dima Virych on 29.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

public protocol StorageObject {
    
}
public protocol Storage {
    
    func add(_: StorageObject)
    func delete(_: StorageObject)
    func getObjects<T: StorageObject>(_: T.Type) -> [T]
    
    func change(_: @escaping () -> Void)
}
