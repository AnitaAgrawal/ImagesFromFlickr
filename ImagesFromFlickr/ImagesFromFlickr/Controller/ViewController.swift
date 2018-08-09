//
//  ViewController.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var flickrPhotos = FlickrPhotos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This will get the images for default search string "kittens"
        getFlickrPhotos()
    }
    
    func getFlickrPhotos() {
        flickrPhotos.getPhotos { success in
            if success {
                DispatchQueue.main.async {
                        self.imageCollectionView.insertSections([self.imageCollectionView.numberOfSections])
                    
                }
            }else {
                //Handle failure cases
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //Making each page a section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return flickrPhotos.photos.count
    }
    //Making per page items as items in section
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return flickrPhotos.photos[section].count ;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.ImagesCollectionViewCell,
                                                            for: indexPath) as? ImageCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.updateCellWithDetails(photoDetails: flickrPhotos.photos[indexPath.section][indexPath.row])
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Dividing the screen width into 3 cells with 10 points space between each cell including leading and trailing
        let width = (AppConstants.ScreenWidth - 40)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Logic for pagination
        // let page = 1, perpage = 30, total = 10000
        //let section = 0, row = 21, photos.count = 30
        //if (1*30 < 10000) true
        //if (0*30 + 24 == (1*30 - 6)) true // we have only two more rows left, so get photos for another page
            if (flickrPhotos.page * flickrPhotos.perpage) < flickrPhotos.total {
                if ((indexPath.section * flickrPhotos.perpage) + indexPath.row == (flickrPhotos.photos.count * flickrPhotos.perpage) - 6) {
                    getFlickrPhotos()
                }// We are not at the bottom of the collection view and still have many item to show to user.
            }//else we are at the end of the table and displayed all the availble images.
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Setting search string in the model as it will provide search text to api call and clear the old data
        flickrPhotos.searchStr = searchBar.text ?? "kittens"
        imageCollectionView.reloadData()
        getFlickrPhotos()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
