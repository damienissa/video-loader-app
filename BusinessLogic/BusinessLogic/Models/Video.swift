//
//  Video.swift
//  Core
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation
import RealmSwift
import Networking

public class Video: Object {

    @objc dynamic public var name: String = ""
    @objc dynamic public var id: String = ""
    @objc dynamic public var thumbnail: String = ""
    
    public let resources = List<Resource>()
    
    override public class func primaryKey() -> String? {
        "id"
    }
}


public class Resource: Object, Downloadable {
   
    @objc dynamic public var id: String = ""
    @objc dynamic public var urlStr: String = ""
    @objc dynamic public var destinationUrlStr: String = ""
    @objc dynamic public var format: String = ""
    @objc dynamic public var filesize: String = ""
    @objc dynamic public var resourceExtension: String = ""
    @objc dynamic public var downloaded: Bool = false
    @objc dynamic public var localID: String = UUID().uuidString

    public var url: URL {
        URL(string: urlStr)!
    }
    
    public var destinationUrl: URL {
        URL(fileURLWithPath: destinationUrlStr)
    }
    
    override public class func primaryKey() -> String? {
        "id"
    }
    
    public func set(destination url: URL, completion: (() -> Void)? = nil) {
        
        DatabaseManager.shared.change { [weak self] in
            
            self?.destinationUrlStr = url.path
            completion?()
        }
    }
}
