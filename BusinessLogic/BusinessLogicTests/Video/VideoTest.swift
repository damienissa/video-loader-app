//
//  VideoTest.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Core

class VideoTest: XCTestCase {

    func test_video_factory() {
        
        let response = VProvider()
        let sut = VideoFactory.video(from: response)
        
        XCTAssertEqual(sut.id, response.id)
        XCTAssertEqual(sut.resources.first?.urlStr, response.resources.first?.url)
    }
    
    func test_resource_factory() {
        
        let resource = VProvider.Resource(url: "http://a-url.com", format: "1280 x 768", filesizePretty: "2 Mb", streamExtension: "mp4")
        let sut = VideoFactory.resource(from: resource)
        
        XCTAssertEqual(sut.urlStr, resource.url)
        XCTAssertEqual(sut.format, resource.format)
        XCTAssertEqual(sut.filesize, resource.filesizePretty)
        XCTAssertEqual(sut.resourceExtension, resource.streamExtension)
    }
    
    func test_video_url() {
        
        let resource = VProvider.Resource(url: "http://a-url.com",
                                          format: "1280 x 768",
                                          filesizePretty: "2 Mb",
                                          streamExtension: "mp4")
        let sut = VideoFactory.resource(from: resource)
        
        
        XCTAssertEqual(sut.url.absoluteString, resource.url)
    }
    
    func test_video_destination_empty_url() {
        
        let resource = VProvider.Resource(url: "http://a-url.com",
                                          format: "1280 x 768",
                                          filesizePretty: "2 Mb",
                                          streamExtension: "mp4")
        let sut = VideoFactory.resource(from: resource)
        
        
        XCTAssertEqual(sut.destinationUrl.path, "/private/tmp")
    }
    
    func test_video_destination_url() {
        
        let resource = VProvider.Resource(url: "http://a-url.com",
                                          format: "1280 x 768",
                                          filesizePretty: "2 Mb",
                                          streamExtension: "mp4")
        let sut = VideoFactory.resource(from: resource)
        let url = destenation(with: UUID().uuidString)
        let exp = expectation(description: "Wait for setting")
        
        sut.set(destination: url) {
            
            XCTAssertEqual(sut.destinationUrl, url)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    struct VProvider: VideoProvider {
        
        struct Resource: ResourceProvider {
            
            var url: String
            var format: String
            var filesizePretty: String
            var streamExtension: String
        }
        
        var title: String = "1"
        
        var id: String = "1"
        
        var thumbnail: String = "1"
        
        var resources: [ResourceProvider] = []
    }
    
    func destenation(with name: String) -> URL {

        getDocumentsDirectory().appendingPathComponent(name)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
