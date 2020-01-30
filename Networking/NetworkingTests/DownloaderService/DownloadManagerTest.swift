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
        
        sut.download(item: item, to: SessionSpy.destinationURL) { _ in }
        
        XCTAssertEqual(spy.downloadingItems, [item.url])
    }
    
    func test_didFinishDownloading() {
        
        let spy = SessionSpy()
        let sut = makeSUT(spy)
        let item = makeDownloadItem()
        let exp = expectation(description: "Wait for completion")
        sut.download(item: item, to: SessionSpy.destinationURL) { result in
            
            switch result {
            case let .success(downloaded as DownloadItem):
                XCTAssertEqual(downloaded, item)
                XCTAssertEqual(downloaded.destinationUrl, SessionSpy.destinationURL)
            default:
                XCTFail("Exepted success with downloaded \(item)")
            }
            
            exp.fulfill()
        }
        spy.finished(with: .result(.success(SessionSpy.destinationURL)))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_didFinishDownloading_withError() {
        
        let spy = SessionSpy()
        let sut = makeSUT(spy)
        let item = makeDownloadItem()
        let exp = expectation(description: "Wait for completion")
        let startError = NSError(domain: "Some Error", code: 1)
        spy.error = startError
        
        sut.download(item: item, to: SessionSpy.destinationURL) { result in
            
            switch result {
            case let .failure(error):
                XCTAssertEqual(error.localizedDescription, startError.localizedDescription)
            default:
                XCTFail("Exepted failure with \(startError)")
            }
            
            exp.fulfill()
        }
        
        spy.finished(with: .result(.failure(startError)))
        
        wait(for: [exp], timeout: 1)
    }
    
    func testProgress() {
        
        let item = makeDownloadItem()
        let spy = SessionSpy()
        let sut = makeSUT(spy)
        let exp = expectation(description: "Wait for completion")
        
        
        sut.download(item: item, to: SessionSpy.destinationURL, progress: {
            progress in
            
            XCTAssertEqual(progress, 30)
        }) { res in
            XCTAssertEqual(try? res.get().destinationUrl, SessionSpy.destinationURL)
            exp.fulfill()
        }
        
        spy.finished(with: .progress(30))
        spy.finished(with: .result(.success(SessionSpy.destinationURL)))
        
        wait(for: [exp], timeout: 1)
    }
    
    
    // MARK: - Helper
    
    private func makeSUT(_ spy: DownloadSession, file: StaticString = #file, line: UInt = #line) -> DownloadManager {
        
        let manager = DownloadManager(session: spy)
        
        trackForMemoryLeaks(manager, file: file, line: line)
        
        return manager
    }
}

