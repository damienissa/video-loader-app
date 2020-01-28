//
//  DownloadManager.swift
//  Networking
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Notifications

public let kDownloadManagerDidUpdateProgressNotification = "DownloadManagerDidUpdateProgressNotification"
public let kDownloadManagerDidStartDownloadingNotification = "DownloadManagerDidStartDownloadingNotification"
public let kDownloadManagerDidFinishDownloadingNotification = "DownloadManagerDidFinishDownloadingNotification"
public let kDownloadManagerDidRemoveNotification = "DownloadManagerDidRemoveNotification"


// MARK: - DownloadManaager

public final class AlamofireBasedDownloadManager: NSObject {
    
    // MARK: - Properties
    
    fileprivate let downloadManager = SessionManager()
    fileprivate var queue = [Downloadable]()
    fileprivate var downloadRequests = [DownloadRequest]()
    
    
    // MARK: - Public Action
    
    
    // MARK: - Private Actions
    
    fileprivate func download(item: Downloadable) {
        
        guard !item.url.absoluteString.isEmpty else {
            return
        }
        
        DispatchQueue.main.async {
            
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
                let percent = Int( Float(progress.completedUnitCount) / Float(progress.totalUnitCount) * 100)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: kDownloadManagerDidUpdateProgressNotification), object: item, userInfo: ["percent": percent]))
            }
        }
        
        request.response { response in
            
            DispatchQueue.main.async {
                
                self.purgeFromQueue(item: item)
                if let error = response.error {
                    
                    print("\(error)")
                }
                
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: kDownloadManagerDidFinishDownloadingNotification), object: item, userInfo: ["error": response.error ?? Unknown.error]))
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
}

extension AlamofireBasedDownloadManager: Downloader {
    
    public func download(items: [Downloadable]) {
        
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
    
    public func cancel(items: [Downloadable]) {
        
        for item in items {
            cancel(item: item)
        }
    }
    
    public func removeDownloaded(items: [Downloadable]) {
        
        for item in items {
            remove(item: item)
        }
    }
    
    public func removeDownloaded(item: Downloadable) {
        
        remove(item: item)
    }
    
    public func isDownloading(item: Downloadable) -> Bool {
        
        return downloadRequest(forItem: item) != nil
    }
    
    public func downloadingProgress(forItem item: Downloadable) -> Double {
        
        return downloadRequest(forItem: item)?.progress.fractionCompleted ?? 0
    }
}