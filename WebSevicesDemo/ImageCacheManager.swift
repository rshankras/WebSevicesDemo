//
//  ImageCacheManager.swift
//  WebSevicesDemo
//
//  Created by Ravi Shankar on 16/03/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import UIKit

class ImageCacheManager {

    static let sharedInstance: NSCache = {
        let cache = NSCache()
        
        cache.name = "ImageCache"
        cache.countLimit = 25
        cache.totalCostLimit = 10*1024*1024
        
        return cache
    }()
    private init() {}
}

extension NSURL {
    func downloadImage(completion:(image: UIImage) -> Void) {
        let cache = ImageCacheManager.sharedInstance
        
        if let data = cache.objectForKey(self.absoluteString) {
            let image = UIImage(data: data as! NSData)
            completion(image: image!)
        } else {
    
            let task = NSURLSession.sharedSession().dataTaskWithURL(self, completionHandler: { (data, response, error) -> Void in
                
                if error == nil {
                    if let data = data {
                        cache.setObject(data, forKey: self.absoluteString)
                        let image = UIImage(data: data)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(image: image!)
                        })
                    }
                }
            })
            
            task.resume()
        }
    }
}
