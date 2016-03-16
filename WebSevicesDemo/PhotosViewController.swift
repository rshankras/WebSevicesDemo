//
//  PhotosViewController.swift
//  WebSevicesDemo
//
//  Created by Ravi Shankar on 14/03/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosViewController: UICollectionViewController {
    
    private var photos = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let serviceManager = ServiceManager()
        serviceManager.searchPhotos("UK") { (results) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.photos = results
                self.collectionView?.reloadData()
            })

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        

        let photo = photos[indexPath.row]
        
        let farm    = photo["farm"] as? Int
        let server  = photo["server"] as? String
        let id      = photo["id"] as? String
        let secret  = photo["secret"] as? String
        
        
        let imageURLStr = "https://farm\(farm!).staticflickr.com/\(server!)/\(id!)_\(secret!)_m.jpg"
        
        let url = NSURL(string: imageURLStr)
        
        url?.downloadImage({ (image) -> Void in
            cell.imageView.image = image
        })
        
        /*
        
        if let url = url {
            let data = NSData(contentsOfURL: url)
            if let data = data {
                let image = UIImage(data: data)
                cell.imageView.image = image
            }
        }
*/
 
        return cell
    }
}
