//
//  TestParser.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Core

enum Unknown: Error {
    case error
}

class ParserTest: XCTestCase {
    
    func test_process_empty_response() {
        
        let result = makeSUT().process(makeResponse())
        switch result {
        case .failure(let error as ProcessingError):
            print(error)
        default:
            XCTFail("Excepted error, \(result)")
        }
    }
    
    func test_process_empty_data_response() {
        
        let result = makeSUT().process(makeResponse(Data("{}".utf8), makeURLResponse(status: 200)))
        
        switch result {
        case .failure(let error as ProcessingError):
            print(error)
        default:
            XCTFail("Excepted error, \(result)")
        }
    }
    
    func test_process_wrong_status_response() {
        
        let code = 300
        let result = makeSUT().process(makeResponse(Data("{}".utf8), makeURLResponse(status: code)))
        
        switch result {
        case .failure(let error as ProcessingError):
            XCTAssertEqual(error, ProcessingError.statusCode(code))
            XCTAssertEqual(error.localizedDescription, "\(code)")
        default:
            XCTFail("Excepted error, \(result)")
        }
    }
    
    func test_process_successCase() {
        
        let result = makeSUT().process(makeResponse(Data(respString.utf8), makeURLResponse(status: 200)))
        
        switch result {
        case .success:
            break
        default:
            XCTFail("Excepted error, \(result)")
        }
    }
    
    func test_process_with_Error() {
        
        let error = NSError(domain: "Some error", code: 1)
        let result = makeSUT().process(makeResponse(nil, makeURLResponse(status: 200), error))
        
        switch result {
        case .failure(let err as ProcessingError):
            XCTAssertEqual(err, ProcessingError.default(error), "\(err)")
        default:
            XCTFail("Excepted error, \(result)")
        }
    }
    
    func test_process_with_emptyData_noError() {
        
        let result = makeSUT().process(makeResponse(nil, makeURLResponse(status: 200), nil))
        
        switch result {
        case .failure(let err as ProcessingError):
            XCTAssertEqual(err, ProcessingError.unknown, "\(err)")
        default:
            XCTFail("Excepted error, \(result)")
        }
    }
    
    func test_responseWithNoStatus() {
        
        let result = makeSUT().process(makeResponse(nil, makeURLResponse(), nil))
        
        switch result {
        case .failure(let err as ProcessingError):
            XCTAssertEqual(err, ProcessingError.statusCode(-1), "\(err)")
        default:
            XCTFail("Excepted error, \(result)")
        }
    }
    
    
    // MARK: - Helper
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> Parser<FetchResponse> {
        
        let parser = Parser<FetchResponse>()
        
        trackForMemoryLeaks(parser, file: file, line: line)
        
        return parser
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
}


fileprivate let respString = """
{
    "status": true,
    "message": "Successfully received info.",
    "description": "\\u0421\\u043a\\u0430\\u0447\\u0430\\u0442\\u044c LOST ARK \\u0431\\u0435\\u0441\\u043f\\u043b\\u0430\\u0442\\u043d\\u043e: https:\\/\\/bit.ly\\/2Ro8KlG\\n\\n\\u0418\\u043d\\u0444\\u0430 \\u043f\\u043e \\u0421\\u0422\\u0420\\u0418\\u041c\\u0410\\u041c \\u0442\\u0443\\u0442:\\n\\u2022 \\u0418\\u043d\\u0441\\u0442\\u0430\\u0433\\u0440\\u0430\\u043c: https:\\/\\/www.instagram.com\\/the_varp\\/\\n\\n\\u2022 \\u041f\\u043e\\u0434\\u043f\\u0438\\u0448\\u0438\\u0441\\u044c \\u043d\\u0430 \\u041c\\u043e\\u0439 \\u0412\\u0442\\u043e\\u0440\\u043e\\u0439 \\u041a\\u0430\\u043d\\u0430\\u043b! (\\u0441\\u0442\\u0440\\u0438\\u043c\\u044b \\u0425\\u043e\\u0440\\u0440\\u043e\\u0440\\u043e\\u0432)\\nhttps:\\/\\/www.youtube.com\\/channel\\/UCvVD2s6n9EiDD3ocFc3DNBg?sub_confirmation=1\\n\\n\\u2022 \\u041f\\u043e\\u0434\\u043f\\u0438\\u0448\\u0438\\u0441\\u044c \\u043d\\u0430 \\u041f\\u043e-\\u0411\\u0440\\u0430\\u0442\\u0441\\u043a\\u0438!\\nhttps:\\/\\/www.youtube.com\\/channel\\/UCelUU2gmSw3A0KWo364vIJg\\/?sub_confirmation=1\\n\\n\\u0420\\u0430\\u0437\\u0433\\u043e\\u0432\\u043e\\u0440 \\u0441 \\u0411\\u042b\\u0414\\u041b\\u041e\\u041c \\u0432 \\u0427\\u0430\\u0442 \\u0420\\u0443\\u043b\\u0435\\u0442\\u043a\\u0435 | \\u0414\\u0435\\u0434 \\u0422\\u0438\\u0445\\u043e\\u043d",
    "uploader": "\\u041f\\u043e-\\u0411\\u0440\\u0430\\u0442\\u0441\\u043a\\u0438",
    "url": "https:\\/\\/www.youtube.com\\/watch?v=PUSJhSVcaJ8",
    "id": "PUSJhSVcaJ8",
    "is_playlist": false,
    "site": "YouTube",
    "title": "\\u0420\\u0430\\u0437\\u0433\\u043e\\u0432\\u043e\\u0440 \\u0441 \\u0411\\u042b\\u0414\\u041b\\u041e\\u041c \\u0432 \\u0427\\u0430\\u0442 \\u0420\\u0443\\u043b\\u0435\\u0442\\u043a\\u0435 | \\u0414\\u0435\\u0434 \\u0422\\u0438\\u0445\\u043e\\u043d",
    "like_count": 59769,
    "dislike_count": 524,
    "view_count": 450976,
    "duration": 414,
    "upload_date": "20200125",
    "tags": ["\\u043f\\u043e \\u0431\\u0440\\u0430\\u0442\\u0441\\u043a\\u0438", "\\u043f\\u043e-\\u0431\\u0440\\u0430\\u0442\\u0441\\u043a\\u0438", "\\u0411\\u0438\\u0442\\u0431\\u043e\\u043a\\u0441", "\\u0410\\u043b\\u0438\\u043a", "\\u0430\\u043b\\u0438\\u043a \\u0431\\u0438\\u0442\\u0431\\u043e\\u043a\\u0441", "\\u043a\\u0430\\u043f\\u043b\\u044f \\u0431\\u0438\\u0442\\u0431\\u043e\\u043a\\u0441", "\\u0427\\u0430\\u0442", "\\u0427\\u0430\\u0442 \\u0420\\u0443\\u043b\\u0435\\u0442\\u043a\\u0430", "\\u0420\\u0443\\u043b\\u0435\\u0442\\u043a\\u0430", "\\u0432 \\u0427\\u0430\\u0442 \\u0420\\u0443\\u043b\\u0435\\u0442\\u043a\\u0435", "\\u0420\\u0430\\u0437\\u0433\\u043e\\u0432\\u043e\\u0440", "\\u0420\\u0430\\u0437\\u0433\\u043e\\u0432\\u043e\\u0440 \\u0441", "\\u0447\\u0430\\u0442\\u0440\\u0443\\u043b\\u0435\\u0442\\u043a\\u0430", "\\u0440\\u0430\\u0437\\u0433\\u043e\\u0432\\u043e\\u0440 \\u0441 \\u0411\\u042b\\u0414\\u041b\\u041e\\u041c", "\\u0411\\u044b\\u0434\\u043b\\u043e \\u0432 \\u0427\\u0430\\u0442 \\u0440\\u0443\\u043b\\u0435\\u0442\\u043a\\u0435", "\\u0411\\u042b\\u0414\\u041b\\u041e", "\\u0414\\u0435\\u0434", "\\u0414\\u0435\\u0434 \\u0422\\u0438\\u0445\\u043e\\u043d", "\\u0422\\u0438\\u0445\\u043e\\u043d"],
    "uploader_url": "http:\\/\\/www.youtube.com\\/channel\\/UCelUU2gmSw3A0KWo364vIJg",
    "thumbnail": "https:\\/\\/i.ytimg.com\\/vi\\/PUSJhSVcaJ8\\/maxresdefault.jpg",
    "streams": [{
        "url": "https:\\/\\/r2---sn-5oxmp55u-8pxe.googlevideo.com\\/videoplayback?expire=1580243072&ei=IEQwXve7HMqK8gOHponoDQ&ip=109.70.100.22&id=3d448985255c689f&itag=22&source=youtube&requiressl=yes&mm=31%2C29&mn=sn-5oxmp55u-8pxe%2Csn-4g5e6nle&ms=au%2Crdu&mv=m&mvi=1&pl=24&initcwndbps=340000&vprv=1&mime=video%2Fmp4&ratebypass=yes&dur=413.617&lmt=1580126658026446&mt=1580221323&fvip=2&fexp=23842630&c=WEB&txp=5535432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cratebypass%2Cdur%2Clmt&sig=ALgxI2wwRQIhAKqvVqNt85Co3Y7_Sv9EkuiIcsI3IMNJo1RR_gqM4L6oAiB6v2e281T-dR1n_VUgJmKzmW_9LUgREXo7jEVLqxsaUQ%3D%3D&lsparams=mm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AHylml4wRAIgMh37_MRxB_qr-e9Hy22DM1aLiwT_jZGouWR6TQ7O9DcCICM9LMalWxHuv1XotdUMnbD2Xj9zJecP8WhGqUTsKdzu",
        "format": "1280x720 (720p)",
        "format_note": "720p",
        "extension": "mp4",
        "video_codec": "avc1.64001F",
        "audio_codec": "mp4a.40.2",
        "height": 720,
        "width": 1280,
        "fps": null,
        "fmt_id": "22",
        "filesize": null,
        "filesize_pretty": "-",
        "has_audio": true,
        "has_video": true,
        "is_hd": true
    }]
}
"""
