//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Networking

class NetworkingTests: XCTestCase {

    func test_simpleRequest() {
        
        var result: Data?
        let exp = self.expectation(description: "test_simpleRequest")
        makeSUT().execute(makeRequest(), processor: ProcessorSPY()) { res in
            
            result = res
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(result)
    }
    
    func test_download_method() {
        
        let item = makeDownloadable()
        let loader = DownloaderSpy()
        makeSUT(loader).download(item: item) { _ in }
        
        XCTAssertEqual(loader.responsedItems as? [DownloadItem], [item])
    }
    
    func test_didRecieve_notification() {
        
        let item = makeDownloadable()
        let loader = DownloaderSpy()
        let sut = makeSUT(loader)
        let exp = expectation(description: "Wait for completion")
        var result: DownloadingResult?
        
        sut.download(item: item) { res in
            result = res
            exp.fulfill()
        }
        
        sut.didRecieve(makeNotification(item))
        
        wait(for: [exp], timeout: 1)
        
        switch result {
        case let .success(responsed as DownloadItem):
            XCTAssertEqual(responsed, item)
        default:
            XCTFail("Except success with \(item)")
        }
    }
    
    func test_didRecieve_notification_withError() {
        
        let item = makeDownloadable()
        let loader = DownloaderSpy()
        let startError = NSError(domain: "Some error", code: 1)
        let sut = makeSUT(loader)
        let exp = expectation(description: "Wait for completion")
        
        var result: DownloadingResult?
        
        sut.download(item: item) { res in
            result = res
            exp.fulfill()
        }
        
        sut.didRecieve(makeNotification(item, info: ["error": startError]))
        
        wait(for: [exp], timeout: 1)
        
        switch result {
        case let .failure(error as NSError):
            XCTAssertEqual(startError, error)
        default:
            XCTFail("Except failure with \(item)")
        }
    }
    
    func test_didRecieve_notification_withOutObject() {
        
        let item = makeDownloadable()
        let loader = DownloaderSpy()
        let startError = NSError(domain: "Some error", code: 1)
        let sut = makeSUT(loader)
        let exp = expectation(description: "Wait for completion")
        var result: DownloadingResult?
        
        sut.download(item: item) { res in
            result = res
            exp.fulfill()
        }
        
        sut.didRecieve(makeNotification(nil, info: ["error": startError]))
        
        wait(for: [exp], timeout: 1)
        
        switch result {
        case let .failure(error as NSError):
            XCTAssertEqual(startError, error)
        default:
            XCTFail("Except failure with \(item)")
        }
    }
    
    func test_didRecieve_empty_notification() {
        
        let item = makeDownloadable()
        let loader = DownloaderSpy()
        let sut = makeSUT(loader)
        let exp = expectation(description: "Wait for completion")
        var result: DownloadingResult?
        
        sut.download(item: item) { res in
            result = res
            exp.fulfill()
        }
        
        sut.didRecieve(makeNotification(nil))
        
        wait(for: [exp], timeout: 1)
        
        switch result {
        case let .failure(error as Unknown):
            XCTAssertEqual(error, Unknown.error)
        default:
            XCTFail("Except failure with \(Unknown.error)")
        }
    }
    
    
    // MARK: - Helper
    
    private func makeSUT(_ downloader: Downloader = DownloaderSpy()) -> NetworkingService {
        NetworkService(downloader: downloader)
    }
    
    private func makeDownloadable() -> DownloadItem {
        
        DownloadItem(id: "1", url: URL(string: "https://google.com")!, destinationUrl: URL(string: "https://google.com")!, downloaded: true)
    }
    
    private func makeNotification(_ item: Downloadable?, info: [String: NSError]? = nil) -> Notification {
        Notification(name: Notification.Name(rawValue: kDownloadManagerDidFinishDownloadingNotification), object: item, userInfo: info)
    }
    
    private func makeRequest() -> URLRequest {
        URLRequest(url: URL(string: "https://google.com")!)
    }
    
    struct ProcessorSPY: ResponseProcessor {
        
        struct D: Encodable {
            let name: String
        }
        enum Err: Error {
            case unknown
        }

        func process(_ response: Response) -> Data? {
            
            response.data
        }
    }
}
