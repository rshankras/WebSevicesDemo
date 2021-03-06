//
//  ServiceManager.swift
//  WebSevicesDemo
//
//  Created by Ravi Shankar on 14/03/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import Foundation


class ServiceManager {
    
    let API_KEY = "c4a9b68616b5ef8113d021dfbec8deec"
    let URL = "https://api.flickr.com/services/rest/"
    let METHOD = "flickr.photos.search"
    let FORMAT_TYPE:String = "json"
    let JSON_CALLBACK:Int = 1
    let PRIVACY_FILTER:Int = 1
    let DATE_SORT = "date-taken-desc"
    
    func searchPhotos(_ searchText: String, completionHandler:@escaping (NSArray) -> Void) {

        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&tags=\(String(describing: searchText.replacingOccurrences(of: " ", with: "%20")))&per_page=25&format=json&nojsoncallback=1"
        
        let url = Foundation.URL(string: urlString)
        
        if let url = url {
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                if error == nil {
                    if let data = data {
                        
                        do {
                            
                            let result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                            
                            if let photoData = result?["photos"] as? [String:Any] {
                                if let photos = photoData["photo"] {
                                    completionHandler((photos as? NSArray)!)
                                }
                            }
                            
                            
                        } catch (let error as NSError) {
                            print(error.localizedDescription)
                        }
                    }
                }
                
            })
            
            task.resume()
            
        }

    }
}
