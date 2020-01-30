//
//  DatabaseManagerTest.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 29.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Core

class DatabaseManagerTest: XCTestCase {
    
    func test_init() {
        
        let (_, db) = makeSUT()
        
        XCTAssertEqual(db.objects, [])
        XCTAssertEqual(DatabaseManager.migrate().schemaVersion, 2)
    }
    
    func test_objectsArray() {
        
        let sut = try? DatabaseManager.realm()
        XCTAssertEqual(sut?.getObjects(Resource.self), [])
    }
    
    func test_addOneObject() {
        
        let (sut, db) = makeSUT()
        let res = Resource()
        let exp = expectation(description: "test_addOneObject")
        sut.add(res)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(db.objects, [res])
    }
    
    func test_delete_OneObject() {
        
        let (sut, db) = makeSUT()
        let res = Resource()
        let exp = expectation(description: "test_delete_OneObject")
        sut.add(res)
        sut.delete(res)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(db.objects, [])
    }
    
    func test_change_OneObject() {
        
        let (sut, _) = makeSUT()
        let res = Resource()
        let exp = expectation(description: "test_delete_OneObject")
        sut.change {
            res.downloaded = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssert(res.downloaded)
    }
    
    func makeSUT() -> (Storage, RealmLikeSPY) {
        let store = RealmLikeSPY()
        let db = DatabaseManager(store)
        
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(db)
        
        return (db, store)
    }
    
    class RealmLikeSPY: RealmLike {
        
        var objects: [Object] = []
        
        func add(_ object: Object, update: UpdatePolicy) {
            objects.append(object)
        }
        
        func delete(_ object: Object) {
            objects.remove(at: objects.firstIndex(of: object) ?? 0)
        }
        
        func objects<Element>(_ type: Element.Type) -> Results<Element> where Element : Object {
            
            Realm.Configuration.defaultConfiguration = DatabaseManager.migrate()
            
            return try! Realm().objects(Element.self)
        }
        
        func write(withoutNotifying tokens: [NotificationToken], _ block: (() throws -> Void)) throws {
            
            try block()
        }
    }
}
