import Foundation

import RealmSwift


// MARK: - Properties

fileprivate let storeFileNameDefault = "YouSaver"
fileprivate let storeFileExtension = ".realm"

public class DatabaseManager: NSObject {
    
    
    // MARK: - Singleton
    
    public static let shared = DatabaseManager()
    
    
    // MARK: Lifecycle
    
    init(storeName: String = storeFileNameDefault) {
    
        var config = DatabaseManager.migrate()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(storeName + storeFileExtension)
        Realm.Configuration.defaultConfiguration = config
        
        super.init()
    }
    
    func deleteStoreFile(storeName: String = storeFileNameDefault) {
      
        let fileURL = storeFileURL()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try! FileManager.default.removeItem(at: fileURL as URL)
        }
    }
    
    func storeFileURL(storeName: String = storeFileNameDefault) -> URL {
       
        let fileURL = Realm.Configuration().fileURL!.deletingLastPathComponent().appendingPathComponent(storeName + storeFileExtension)

        return fileURL
    }
    
    
    // MARK: Actions
    
    public func add(_ object: Object) {
        write { realm in
            realm.add(object, update: .all)
        }
    }
    
    public func addArray(_ array: [Object]) {
        write { realm in
            realm.add(array, update: .all)
        }
    }
    
    public func addArray<T: Object>(array: List<T>) {
        
        write { realm in
            realm.add(array)
        }
    }
    
    public func change(_ changesBlock: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            self.write { _ in
                changesBlock()
            }
        }
    }
    
    public func delete(_ object: Object) {
        write { realm in
            realm.delete(object)
        }
    }
    
    public func deleteObjects<T: Object>(_ objects: List<T>) {
        write { realm in
            realm.delete(objects)
        }
    }
    
    public func deleteObjects<T: Object>(_ objects: Results<T>) {
        write { realm in
            realm.delete(objects)
        }
    }
    
    fileprivate func write(_ changes: (Realm) -> Void) {
        
        let realm = try! Realm()
        do {
            try realm.safeWrite {
                changes(realm)
            }
        } catch let error as NSError {
            NSLog(error.description)
        }
    }
    
    public func objects<T: Object>(_ type: T.Type = T.self) -> Results<T> {
        
        let realm = try! Realm()
        let results = realm.objects(T.self)
        
        return results
    }
}


// MARK: Objects for Key

extension DatabaseManager {
    
    public func objectsForKey<T: Object, V>(_ type: T.Type, key: String, value: V) -> Results<T> {
        
        return objects().filter("\(key) == %@", (value as AnyObject))
    }
    
    public func objectsForKeys<T: Object, V>(_ type: T.Type, key: String, value: V) -> Results<T> {
        
        return objects().filter("\(key) IN %@", (value as AnyObject))
    }
    
    public func objectForPrimaryKey<T: Object, V>(key: String, value: V) -> T? {
        
        return objects().filter("\(key) == %@", (value as AnyObject)).first
    }
}


// MARK: - Thread

extension DatabaseManager {
    
    func resolveThreadFor<T: Object>(_ results: Results<T>, _ completion: @escaping (_ results: Results<T>?) -> Void) {
        
        let ref = ThreadSafeReference(to: results)
        
        DispatchQueue.main.async {
        
            let realm = try! Realm()
            let resolvedResults = realm.resolve(ref)
            
            completion(resolvedResults)
        }
    }
}


// MARK: - Migrate

extension DatabaseManager {
    
    static func migrate() -> Realm.Configuration {
        
        return Realm.Configuration(schemaVersion: 2, migrationBlock: { _, _ in })
    }
}


// MARK: Array

extension Results {
    
    var array: [Element] {
        
        return Array(self)
    }
}

extension Realm {
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
