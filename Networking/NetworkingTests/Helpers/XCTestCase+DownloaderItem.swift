//
//  XCTestCase+DownloaderItem.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func makeDownloadItem() -> DownloadItem {
        
        DownloadItem(id: "1", url: URL(string: "https://google.com")!, destinationUrl: URL(string: "https://google.com")!, downloaded: true)
    }
}
