//
//  ServiceManager.swift
//  WebSevicesDemo
//
//  Created by Ravi Shankar on 14/03/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import Foundation


class ServiceManager {
    
    let API_KEY = "YOUR_API_KEY"
    let URL = "https://api.flickr.com/services/rest/"
    let METHOD = "flickr.photos.search"
    let FORMAT_TYPE:String = "json"
    let JSON_CALLBACK:Int = 1
    let PRIVACY_FILTER:Int = 1
    let DATE_SORT = "date-taken-desc"
    
    /*
            Alamofire.request(.GET, URL, parameters: ["method": METHOD, "api_key": API_KEY, "tags":searchText,"sort":DATE_SORT, "privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK]).responseJSON { (response) -> Void in
    
    */
    

    
    func searchPhotos(searchText: String, completionHandler:(NSArray) -> Void) {

        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&tags=\(searchText)&per_page=25&format=json&nojsoncallback=1"
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let request = NSURLRequest(URL: url)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                
                if error == nil {
                    if let data = data {
                        
                        do {
                            
                            let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                            
                            if let photoData = result["photos"] {
                                if let photos = photoData!["photo"] {
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
        
        // define request
        // start session
        // pass the data back to callerr

    }
}