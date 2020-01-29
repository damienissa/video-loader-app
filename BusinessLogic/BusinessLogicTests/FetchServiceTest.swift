//
//  FetchServiceTest.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 29.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Core
import Networking

class FetchServiceTest: XCTestCase {

    
    func test_fillURL() {
            
        let (sut, _, net) = makeSUT()
        let url = URL(string: "http://a-url.com")!
        sut.fetch(for: url) { _ in }
        
        XCTAssert(net.executedRequest!.url!.absoluteString.contains(url.absoluteString), "URLS does not mutch")
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (FetchService<ParserSPY>, parser: ParserSPY, network: NetworkSPY) {
        
        let parser = ParserSPY()
        let network = NetworkSPY()

        return (FetchService(service: network, processor: parser), parser, network)
    }
    
    class NetworkSPY: NetworkingService {
        
        var executedRequest: URLRequest?
        
        func execute<Processor>(_ request: URLRequest, processor: Processor, completion: @escaping (Processor.ProcessingResult) -> Void) where Processor : ResponseProcessor {
        
            executedRequest = request
        }
        
        func download(item: Downloadable, to destenationURL: URL, with progress: DownloadProgress?, completion: @escaping (DownloadingResult) -> Void) {
            
        }
    }

    struct Res: Codable {
        let id: String
    }

    class ParserSPY: ResponseProcessor {
        
        typealias ProcessingResult = Res
        
        func process(_ response: Response) -> Res {
            
            Res(id: "1")
        }
    }
}


