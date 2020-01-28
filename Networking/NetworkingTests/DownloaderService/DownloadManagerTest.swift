//
//  DownloadManagerTest.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Networking

class DownloadManagerTest: XCTestCase {
    
    func test_downloadMethod() {
        
        let spy = SessionSpy()
        let sut = makeSUT(spy)
        let item = makeDownloadItem()
        
        sut.download(item: item, to: SessionSpy.destenationURL) { _ in }
        
        XCTAssertEqual(spy.downloadingItems, [item.url])
    }
    
    func test_didFinishDownloading() {
        
        let spy = SessionSpy()
        let sut = makeSUT(spy)
        let item = makeDownloadItem()
        let exp = expectation(description: "Wait for completion")
        sut.download(item: item, to: SessionSpy.destenationURL) { result in
            
            switch result {
            case let .success(downloaded as DownloadItem):
                XCTAssertEqual(downloaded, item)
                XCTAssertEqual(downloaded.destinationUrl, SessionSpy.destenationURL)
            default:
                XCTFail("Exepted success with downloaded \(item)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_didFinishDownloading_withError() {
        
        let spy = SessionSpy()
        let sut = makeSUT(spy)
        let item = makeDownloadItem()
        let exp = expectation(description: "Wait for completion")
        let startError = NSError(domain: "Some Error", code: 1)
        spy.error = startError
        
        sut.download(item: item, to: SessionSpy.destenationURL) { result in
            
            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
            default:
                XCTFail("Exepted failure with \(startError)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testProgress() {
        
        let item = makeDownloadItem()
        let sut = makeSUT(SessionSpy())
        let exp = expectation(description: "Wait for completion")
        var result: DownloadingResult?
        
        sut.download(item: item, to: SessionSpy.destenationURL, progress: {
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
    
    
    // MARK: - Helper
    
    private func makeSUT(_ spy: DownloadSession) -> DownloadManager {
        DownloadManager(session: spy)
    }
}

