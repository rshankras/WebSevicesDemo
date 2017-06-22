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
    
    fileprivate var photos = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let serviceManager = ServiceManager()
        serviceManager.searchPhotos("UK") { (results) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.photos = results as! [[String: Any]]
                self.collectionView?.reloadData()
            })

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        

        let photo = photos[indexPath.row]
        
        let farm    = photo["farm"] as? Int
        let server  = photo["server"] as? String
        let id      = photo["id"] as? String
        let secret  = photo["secret"] as? String
        
        
        let imageURLStr = "https://farm\(farm!).staticflickr.com/\(server!)/\(id!)_\(secret!)_m.jpg"
        
        let url = URL(string: imageURLStr)
        
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
