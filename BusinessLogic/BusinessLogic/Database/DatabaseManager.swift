import Foundation

import RealmSwift


public typealias Realm = RealmSwift.Realm

// MARK: - Properties

public protocol RealmLike {
    
    typealias Object = RealmSwift.Object
    typealias UpdatePolicy = RealmSwift.Realm.UpdatePolicy
    typealias NotificationToken = RealmSwift.NotificationToken
    typealias Results<Object: RealmCollectionValue> = RealmSwift.Results<Object>
    
    func add(_ object: Object, update: UpdatePolicy)
    func delete(_ object: Object)
    func objects<Element: Object>(_ type: Element.Type) -> Results<Element>
    func write(withoutNotifying tokens: [NotificationToken], _ block: (() throws -> Void)) throws
}

extension Realm: RealmLike { }
extension Video: StorageObject { }
extension Resource: StorageObject { }

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
    
    public func getObjects<T>(_ type: T.Type) -> [T] where T : StorageObject {
        
        Array(objects(String(describing: type))) as! [T]
    }
}

public final class DatabaseManager {
    
    private var queue: OperationQueue?
    
    public static func realm() -> DatabaseManager {
        
        Realm.Configuration.defaultConfiguration = DatabaseManager.migrate()
        
        return DatabaseManager(try! Realm())
    }
    
    
    // MARK: Lifecycle
    
    var store: RealmLike
    
    public init(_ store: RealmLike, queue: OperationQueue? = OperationQueue.current) {
        self.store = store
        self.queue = queue
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
    
    public func objects<T: Object>(_ type: String) -> Results<T> {
        
        let results = store.objects(class_for(type)!)
        
        return results as! Results<T>
    }
    
    fileprivate func write(_ changes: @escaping (RealmLike) -> Void) {
        
        queue?.addOperation {
            autoreleasepool {
                
                try? self.store.write(withoutNotifying: []) {
                    changes(self.store)
                }
            }
        }
    }
    
    private func class_for<T: Object>(_ name: String) -> T.Type? {
        NSClassFromString("Core." + name) as? T.Type
    }
}


// MARK: - Migrate

extension DatabaseManager {
    
    public static func migrate() -> Realm.Configuration {
        
        Realm.Configuration(schemaVersion: 2)
    }
}
