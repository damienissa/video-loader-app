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
        
        let item = makeDownloadItem()
        let loader = DownloaderSpy()
        makeSUT(loader).download(item: item, to: SessionSpy.destenationURL) { _ in }
        
        XCTAssertEqual(loader.responsedItems as? [DownloadItem], [item])
    }
    
    func test_didDownloadObject_withProgress() {
        
        let item = makeDownloadItem()
        let loader = DownloaderSpy()
        let sut = makeSUT(loader)
        let exp = expectation(description: "Wait for completion")
        var result: DownloadingResult?
        
        sut.download(item: item, to: SessionSpy.destenationURL, with: {
            progress in
            
            XCTAssertEqual(progress, 100)
        }) { res in
            result = res
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        switch result {
        case let .success(responsed as DownloadItem):
            XCTAssertEqual(responsed, item)
        default:
            XCTFail("Except success with \(item)")
        }
    }
    
    func test_didDownloadObject() {
        
        let item = makeDownloadItem()
        let loader = DownloaderSpy()
        let sut = makeSUT(loader)
        let exp = expectation(description: "Wait for completion")
        var result: DownloadingResult?
        
        sut.download(item: item, to: SessionSpy.destenationURL) { res in
            result = res
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        switch result {
        case let .success(responsed as DownloadItem):
            XCTAssertEqual(responsed, item)
        default:
            XCTFail("Except success with \(item)")
        }
    }
    
    func test_didDownloadObject_withError() {
        
        let item = makeDownloadItem()
        let loader = DownloaderSpy()
        let startError = NSError(domain: "Some error", code: 1)
        loader.error = startError
        let sut = makeSUT(loader)
        let exp = expectation(description: "Wait for completion")
        
        var result: DownloadingResult?
        
        sut.download(item: item, to: SessionSpy.destenationURL) { res in
            result = res
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        switch result {
        case let .failure(error as NSError):
            XCTAssertEqual(startError, error)
        default:
            XCTFail("Except failure with \(item)")
        }
    }
    
    
    // MARK: - Helper
    
    private func makeSUT(_ downloader: Downloader = DownloaderSpy(), file: StaticString = #file, line: UInt = #line) -> NetworkService {
        let service = NetworkService(downloader: downloader)
        trackForMemoryLeaks(service, file: file, line: line)
        return service
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
