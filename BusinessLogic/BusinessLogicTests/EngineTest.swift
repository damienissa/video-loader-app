//
//  EngineTest.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 29.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Core
import Networking

class EngineTest: XCTestCase {
    
    func test_init() {
        
        let (sut, net, store) = makeSUT()
        
        XCTAssertNotNil(sut)
        XCTAssertNotNil(net)
        XCTAssertNotNil(store)
    }
    
    func test_fetch_createRightRequest() {
        
        let (sut, net, _) = makeSUT()
        let url = URL(string: "http://a-url.com")!
        sut.fetchInfo(for: url) { _ in }
        
        XCTAssert(net.executedRequest!.url!.query!.contains(url.absoluteString))
    }
    
    func test_fetch_info_withError() {
        
        let (sut, net, _) = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let exp = expectation(description: "Wait for fetching")
        sut.fetchInfo(for: url) { result in

            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
            default: XCTFail("Expected errror, \(result) instead")
            }
            
            exp.fulfill()
        }
        
        net.finish(makeResponse())
        
        wait(for: [exp], timeout: 1)
    }

    // MARK: - Helpers
    
    func makeSUT() -> (EngineInterface, NetworkSPY, StorageSPY) {
        
        let net = NetworkSPY()
        let store = StorageSPY()
        let engine = EngineFactory.createEngine(network: net, store: store)
        trackForMemoryLeaks(net)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(engine)
        
        return (engine, net, store)
    }
    
    func makeResponse(_ data: Data? = nil, _ response: URLResponse? = nil, _ error: Error? = nil) -> (data: Data?, reponse: URLResponse?, error: Error?) {
        (data, response, error)
    }
    
    class NetworkSPY: NetworkingService {
        
        typealias Result = Parser<FetchResponse>.ProcessingResult
        
        var executedRequest: URLRequest?
        var collected: ((Result) -> Void)?
        var processor: Parser<FetchResponse>?
        
        func execute<Processor>(_ request: URLRequest, processor: Processor, completion: @escaping (Processor.ProcessingResult) -> Void) where Processor : ResponseProcessor {
        
            executedRequest = request
            collected = completion as? (Result) -> Void
            self.processor = processor as? Parser<FetchResponse>
        }
        
        func download(item: Downloadable, to destenationURL: URL, with progress: DownloadProgress?, completion: @escaping (DownloadingResult) -> Void) {
            
        }
        
        func finish(_ response: (data: Data?, reponse: URLResponse?, error: Error?)) {
            collected?(processor!.process(response))
        }
    }
    
    class StorageSPY: Storage {
        func add(_: StorageObject) {
            
        }
        
        func delete(_: StorageObject) {
            
        }
        
        func objects<T>(_: T.Type) -> [T] where T : StorageObject {
            []
        }
        
        func change(_: @escaping () -> Void) {
            
        }
    }
}

fileprivate extension String {
    
    func value(for key: String) -> String? {

        let arr = split(separator: "=").map(String.init)
        
        return arr.first == key ? arr.last : nil
    }
}
