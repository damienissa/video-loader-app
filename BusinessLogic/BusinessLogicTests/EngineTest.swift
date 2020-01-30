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
    
    func test_engine_weak_error() {
        
        let net = NetworkSPY()
        var sut: EngineInterface? = EngineFactory.createEngine(network: net)
        let url = URL(string: "http://a-url.com")!
        let exp = expectation(description: "Wait for fetching")
        
        sut?.fetchInfo(for: url) { result in
            
            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
            default: XCTFail("Expected errror, \(result) instead")
            }
            
            exp.fulfill()
        }
        sut = nil
        net.finish(makeResponse())
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_engine_with_error() {
        
        let (sut, net, _) = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let startError = NSError(domain: "Some error", code: 1)
        let exp = expectation(description: "Wait for fetching")
        
        sut.fetchInfo(for: url) { result in
            
            switch result {
            case let .failure(error):
                XCTAssertNotNil(error.localizedDescription, startError.localizedDescription)
            default: XCTFail("Expected errror, \(result) instead")
            }
            
            exp.fulfill()
        }
        
        net.finish(makeResponse(nil, nil, startError))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_engine_videos_array() {
        
        let (sut, _, _) = makeSUT()
        XCTAssertEqual(sut.videos().count, 0)
    }
    
    func test_dest_set() {
        
        let (sut, _, db) = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let dest = URL(fileURLWithPath: "")
        let resource = Down(id: "1", url: url, destinationUrl: url, downloaded: false)
        sut.set(destination: dest.path, for: resource)
        db.callChange()
        
        XCTAssertEqual(resource.destinationUrl.path, dest.path)
    }
    
    func test_fetch_info() {
        
        let (sut, net, db) = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let exp = expectation(description: "Wait for fetching")
        let videoID = "PUSJhSVcaJ8"
        sut.fetchInfo(for: url) { result in
            
            switch result {
            case let .success(video):
                XCTAssertEqual(db.addCalledCount, 1)
                XCTAssertEqual(video.id, videoID)
            default: XCTFail("Expected success, \(result) instead")
            }
            
            exp.fulfill()
        }
        
        net.finish(makeResponse(Data(respString.utf8), makeURLResponse(status: 200)))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_Download_with_unknown_error() {
        
        let (sut, net, _) = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let resource = Down(id: "1", url: url, destinationUrl: url, downloaded: false)
        let exp = expectation(description: "Wait for fetching")
        sut.download(item: resource, progress: nil) { (result) in
            
            switch result {
            case let .failure(error):
                XCTAssertEqual(error.localizedDescription, Unknown.error.localizedDescription)
            default:
                XCTFail("Excepted error, \(result) instead")
            }
            
            exp.fulfill()
        }
        
        net.downloaded(with: .failure(Unknown.error))
        wait(for: [exp], timeout: 1)
    }
    
    func test_Download_with_nserror() {
        
        let (sut, net, _) = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let resource = Down(id: "1", url: url, destinationUrl: url, downloaded: false)
        let exp = expectation(description: "Wait for fetching")
        sut.download(item: resource, progress: nil) { (result) in
            
            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
            default:
                XCTFail("Excepted error, \(result) instead")
            }
            
            exp.fulfill()
        }
        
        net.downloaded(with: .success(resource))
        wait(for: [exp], timeout: 1)
    }
    
    func test_Download() {
        
        let (sut, net, _) = makeSUT()
        let resource = Resource()
        let exp = expectation(description: "Wait for fetching")
        sut.download(item: resource, progress: nil) { (result) in
            
            switch result {
            case let .success(res):
                XCTAssertEqual(res.localID, resource.localID)
            default:
                XCTFail("Excepted error, \(result) instead")
            }
            
            exp.fulfill()
        }
        
        net.downloaded(with: .success(resource))
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
    
    func makeURLResponse(_ url: URL = URL(string: "http://a-url.com")!, status: Int? = nil) -> URLResponse {
        
        if let status = status {
            return HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil)!
        } else {
            return URLResponse()
        }
    }
    
    class NetworkSPY: NetworkingService {
        
        typealias Result = Parser<FetchResponse>.ProcessingResult
        
        var executedRequest: URLRequest?
        var collected: ((Result) -> Void)?
        var processor: Parser<FetchResponse>?
        var downloader: ((DownloadingResult) -> Void)?
        
        func execute<Processor>(_ request: URLRequest, processor: Processor, completion: @escaping (Processor.ProcessingResult) -> Void) where Processor : ResponseProcessor {
            
            executedRequest = request
            collected = completion as? (Result) -> Void
            self.processor = processor as? Parser<FetchResponse>
        }
        
        func download(item: Downloadable, to destinationURL: URL, with progress: DownloadProgress?, completion: @escaping (DownloadingResult) -> Void) {
            downloader = completion
        }
        
        func finish(_ response: (data: Data?, reponse: URLResponse?, error: Error?)) {
            collected?(processor!.process(response))
        }
        
        func downloaded(with result: DownloadingResult) {
            downloader?(result)
        }
    }
    
    class StorageSPY: Storage {
        
        var addCalledCount = 0
        var change: (() -> Void)?
        
        func add(_: StorageObject) {
            addCalledCount += 1
        }
        
        func delete(_: StorageObject) {
            
        }
        
        func getObjects<T>(_: T.Type) -> [T] where T : StorageObject {
            []
        }
        
        func change(_ change: @escaping () -> Void) {
            self.change = change
        }
        
        func callChange() {
            
            change?()
        }
    }
    
    class Down: Downloadable {
        
        var id: String
        var url: URL
        var destinationUrl: URL
        var downloaded: Bool
        
        init(id: String, url: URL, destinationUrl: URL, downloaded: Bool) {
            
            self.id = id
            self.url = url
            self.destinationUrl = destinationUrl
            self.downloaded = downloaded
        }
    }
}

fileprivate extension String {
    
    func value(for key: String) -> String? {
        
        let arr = split(separator: "=").map(String.init)
        
        return arr.first == key ? arr.last : nil
    }
}
