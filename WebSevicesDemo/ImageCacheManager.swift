//
//  ImageCacheManager.swift
//  WebSevicesDemo
//
//  Created by Ravi Shankar on 16/03/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import UIKit

class ImageCacheManager {

    static let sharedInstance: NSCache = { () -> NSCache<AnyObject, AnyObject> in 
        let cache = NSCache<AnyObject, AnyObject>()
        
        cache.name = "ImageCache"
        cache.countLimit = 25
        cache.totalCostLimit = 10*1024*1024
        
        return cache
    }()
    fileprivate init() {}
}

extension URL {
    func downloadImage(_ completion:@escaping (_ image: UIImage) -> Void) {
        let cache = ImageCacheManager.sharedInstance
        
        if let data = cache.object(forKey: self.absoluteString as AnyObject) {
            let image = UIImage(data: data as! Data)
            completion(image!)
        } else {
    
            let task = URLSession.shared.dataTask(with: self, completionHandler: { (data, response, error) -> Void in
                
                if error == nil {
                    if let data = data {
                        cache.setObject(data as AnyObject, forKey: self.absoluteString as AnyObject)
                        let image = UIImage(data: data)
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion(image!)
                        })
                    }
                }
            })
            
            task.resume()
        }
    }
}
