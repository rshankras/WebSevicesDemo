//
//  PhotosViewController.swift
//  WebSevicesDemo
//
//  Created by Ravi Shankar on 14/03/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var photos = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBar.text = "Famous Quotes"
        searchForPhotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- SearchButton
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchForPhotos()
        searchBar.resignFirstResponder()
    }
    
    func searchForPhotos() {
        let serviceManager = ServiceManager()
        serviceManager.searchPhotos(searchBar.text!) { (results) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.photos = results as! [[String: Any]]
                self.collectionView?.reloadData()
            })
        }
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let length = (UIScreen.main.bounds.width-15)/4
        return CGSize(width: length, height: length)
    }
}
