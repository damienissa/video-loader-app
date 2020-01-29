import Foundation

import RealmSwift


// MARK: - Properties

extension Video: StorageObject {
    
}

extension Resource: StorageObject {
    
}

extension DatabaseManager: Storage {
    
    public func add(_ object: StorageObject) {
        
        if let db = object as? Object {
            add(db)
        }
    }
    
    public func delete(_ object: StorageObject) {
        
        if let db = object as? Object {
            delete(db)
        }
    }
    
    public func objects<T>(_: T.Type) -> [T] where T : StorageObject {
        
        objects() as! [T]
    }
}

public final class DatabaseManager {
    
    private let thread = DispatchQueue(label: "DatabaseManager.Realm")
    
    
    // MARK: Lifecycle
    
    public init() {
        
        Realm.Configuration.defaultConfiguration = DatabaseManager.migrate()
    }
    
    
    // MARK: Actions
    
    public func add<T: Object>(_ object: T) {
        write { realm in
            realm.add(object, update: .all)
        }
    }
    
    public func change(_ changesBlock: @escaping () -> Void) {
    
        self.write { _ in
            changesBlock()
        }
    }
    
    public func delete<T: Object>(_ object: T) {
        write { realm in
            realm.delete(object)
        }
    }
    
    public func objects<T: Object>(_ type: T.Type = T.self) -> [T] {
        
        let realm = try! Realm()
        let results = realm.objects(T.self)
        
        return Array(results)
    }
    
    fileprivate func write(_ changes: @escaping (Realm) -> Void) {
        
        thread.async {
            autoreleasepool {
                let realm = try! Realm()
                do {
                    try realm.write {
                        changes(realm)
                    }
                } catch let error as NSError {
                    NSLog(error.description)
                }
            }
        }
    }
}


// MARK: - Migrate

extension DatabaseManager {
    
    static func migrate() -> Realm.Configuration {
        
        return Realm.Configuration(schemaVersion: 2, migrationBlock: { _, _ in })
    }
}
