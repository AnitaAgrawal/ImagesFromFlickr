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
        // Do any additional setup after loading the view, typically from a nib.
        getFlickrPhotos()
    }
    
    func getFlickrPhotos() {
        flickrPhotos.getRecentPhotos { success in
            if success {
                DispatchQueue.main.async {
                   
                    self.imageCollectionView.insertSections([self.imageCollectionView.numberOfSections])
//                    self.imageCollectionView.reloadData()
                }
            }
        }
    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return flickrPhotos.photos.count
    }
    
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
        cell.backgroundColor = #colorLiteral(red: 0.3490620852, green: 0.3621737957, blue: 0.3706075847, alpha: 1)
        cell.updateCellWithDetails(photoDetails: flickrPhotos.photos[indexPath.section][indexPath.row])
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (AppConstants.ScreenWidth - 40)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if (flickrPhotos.page * flickrPhotos.perpage) < flickrPhotos.total {
                if ((indexPath.section * flickrPhotos.perpage) + indexPath.row == (flickrPhotos.photos.count * flickrPhotos.perpage) - 6) {
                    self.getFlickrPhotos()
                }else {return}
            }
    }
}
