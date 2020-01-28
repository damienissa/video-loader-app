//
//  AlamofireSessionTest.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Networking

class AlamofireSessionTest: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        
        removeFile(at: destenation(with: someImageURL.lastPathComponent))
    }
    
    private static let someImageURL: URL = URL(string: "https://p.bigstockphoto.com/GeFvQkBbSLaMdpKXF1Zv_bigstock-Aerial-View-Of-Blue-Lakes-And--227291596.jpg")!
    
    func test_downloadFinish_withError() {
        
        let sut = makeSUT()
        let exp = expectation(description: "Wait for downloading")
        let url = AlamofireSessionTest.someImageURL
        let dest = AlamofireSessionTest.destenation(with: url.lastPathComponent)
        
        sut.startDownload(item: url.appendingPathComponent("error"), to: dest) { (downloading) in
            
            switch downloading {
            case .progress(let progress): print(progress)
            case .result(let result):
                switch result {
                case .failure(let error):
                    XCTAssertNotNil(error)
                default:
                    XCTFail("Excepted error")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 10)
    }
    
    func test_downloadStart_withWrongDest() {
        
        let sut = makeSUT()
        let exp = expectation(description: "Wait for downloading")
        let url = AlamofireSessionTest.someImageURL
        let dest = URL(string: "http://a-url.com")!
        
        sut.startDownload(item: url, to: dest) { (downloading) in
            
            switch downloading {
            case .progress(let progress): print(progress)
            case .result(let result):
                switch result {
                case .failure(let error):
                    XCTAssertEqual((error as NSError).code, 518)
                default:
                    XCTFail("Excepted error")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 10)
    }
    
    
    
    func test_downloadFinish() {
        
        let sut = makeSUT()
        let exp = expectation(description: "Wait for downloading")
        let url = AlamofireSessionTest.someImageURL
        let destenationURL = AlamofireSessionTest.destenation(with: url.lastPathComponent)
        
        sut.startDownload(item: url, to: destenationURL) { (downloading) in
            
            switch downloading {
            case .progress(let progress): print(progress)
            case .result(let result):
                switch result {
                case .success(let dest):
                    XCTAssertEqual(destenationURL, dest)
                case let .failure(error):
                    XCTFail("Excepted success \(error)")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 10)
    }
    
    
    // MARK: - Helper
    
    func makeSUT() -> DownloadSession {
        
        AlamofireSessionManager()
    }
    
    static func destenation(with name: String) -> URL {

        getDocumentsDirectory().appendingPathComponent(name)
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func removeFile(at url: URL) {
        
        try? FileManager.default.removeItem(atPath: url.path)
    }
}
