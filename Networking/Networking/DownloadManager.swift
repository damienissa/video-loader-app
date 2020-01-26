//
//  DownloadManager.swift
//  Networking
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation
import Alamofire

public protocol Downloadable: class {
    
    var id: String { get }
    var fileSize: Int { get }
    var url: URL { get }
    var destinationUrl: URL { get }
    var downloaded: Bool { get }
    
    var didStartDownloading: ((Downloadable) -> Void)? { get set }
    var didUpdateProgress: ((Downloadable, Int) -> Void)? { get set }
    var didFinishDownloading: ((Downloadable, Error?) -> Void)? { get set }
}

// MARK: - Notifications

let kDownloadManagerDidUpdateProgressNotification = "DownloadManagerDidUpdateProgressNotification"
let kDownloadManagerDidStartDownloadingNotification = "DownloadManagerDidStartDownloadingNotification"
let kDownloadManagerDidFinishDownloadingNotification = "DownloadManagerDidFinishDownloadingNotification"
let kDownloadManagerDidRemoveNotification = "DownloadManagerDidRemoveNotification"


// MARK: - DownloadManaager

class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    
    
    // MARK: - Properties
    
    var backgroundCompletionHandler: (() -> Void)? {
        didSet {
            downloadManager.backgroundCompletionHandler = backgroundCompletionHandler
        }
    }
    
    fileprivate let downloadManager = SessionManager()
    fileprivate var queue = [Downloadable]()
    fileprivate var downloadRequests = [DownloadRequest]()
    
    
    // MARK: - Public Actions
    
    func download(items: [Downloadable]) {
        
        var itemsToQueue = [Downloadable]()
        for item in items {
           
            if item.downloaded {
                continue
            }
            itemsToQueue.append(item)
        }
        
        downloadManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            
            DispatchQueue.main.async {
                
                for item in itemsToQueue {
                    if downloadTasks.filter({ $0.currentRequest?.url == item.url }).isEmpty {
                        
                        self.queue.append(item)
                        self.download(item: item)
                    }
                }
            }
        }
    }
    
    func cancel(items: [Downloadable]) {
        
        for item in items {
            cancel(item: item)
        }
    }
    
    func removeDownloaded(items: [Downloadable]) {
        
        for item in items {
            remove(item: item)
        }
    }
    
    func removeDownloaded(item: Downloadable) {
        
        remove(item: item)
    }
    
    func isDownloading(item: Downloadable) -> Bool {
        
        return downloadRequest(forItem: item) != nil
    }
    
    func downloadingProgress(forItem item: Downloadable) -> Double {
        
        return downloadRequest(forItem: item)?.progress.fractionCompleted ?? 0
    }
    
    
    // MARK: - Private Actions
    
    fileprivate func download(item: Downloadable) {
        
        guard !item.url.absoluteString.isEmpty else {
            return
        }
        
        DispatchQueue.main.async {
            
            item.didStartDownloading?(item)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kDownloadManagerDidStartDownloadingNotification), object: item, userInfo: nil)
        }
        
        let request = downloadManager.download(item.url) { _, _ -> ( destinationURL: URL, options: DownloadRequest.DownloadOptions ) in
            
            DispatchQueue.main.sync {
                
                return (item.destinationUrl, [.createIntermediateDirectories])
            }
        }
      
        
        downloadRequests.append(request)
        
        request.downloadProgress { progress in
            
            DispatchQueue.main.async {
                item.didUpdateProgress?(item, Int( Float(progress.completedUnitCount) / Float(progress.totalUnitCount) * 100) )
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: kDownloadManagerDidUpdateProgressNotification), object: item, userInfo: nil))
            }
        }
        
        request.response { response in
            
            DispatchQueue.main.async {
                
                self.purgeFromQueue(item: item)
                if let error = response.error {
                    
                    print("\(error)")
                }
                
                item.didFinishDownloading?(item, response.error)
                
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: kDownloadManagerDidFinishDownloadingNotification), object: item, userInfo: nil))
            }
        }
    }
    
    
    fileprivate func purgeFromQueue(item: Downloadable) {
        
        if let index = downloadRequests.firstIndex(where: { $0.request?.url == item.url }) {
            downloadRequests.remove(at: index)
        }
        
        if let index = queue.firstIndex(where: { $0.id == item.id }) {
            queue.remove(at: index)
        }
    }
    
    fileprivate func cancel(item: Downloadable) {
        
        purgeFromQueue(item: item)
        
        getTask(forItem: item) { task in
            
            task?.cancel()
        }
    }
    
    fileprivate func getTask(forItem item: Downloadable, completion: @escaping (_ task: URLSessionDownloadTask?) -> Void) {
        
        downloadManager.session.getTasksWithCompletionHandler { _, _, downloadTasks in
            
            DispatchQueue.main.async {
                
                let task = downloadTasks.first(where: { task -> Bool in
                    return task.currentRequest?.url == item.url
                })
                
                completion(task)
            }
        }
    }
    
    fileprivate func remove(item: Downloadable) {
        
        let filePath = item.destinationUrl.path
        guard FileManager.default.fileExists(atPath: filePath) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch let error {
            print(error)
        }
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: kDownloadManagerDidRemoveNotification), object: item, userInfo: nil))
    }
    
    fileprivate func downloadRequest(forItem item: Downloadable) -> DownloadRequest? {
        
        return downloadRequests.first(where: { request -> Bool in
            return request.request?.url == item.url
        })
    }
    
    
    // MARK: Helpers
    
    fileprivate func getQueueFilesSize() -> Int {
        
        var size = 0
        for item in queue {
            size += item.fileSize
        }
        return size
    }
}
