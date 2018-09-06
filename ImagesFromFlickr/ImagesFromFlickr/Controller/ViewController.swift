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
    
    var imageViewModel = ImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewModel.delegate = self
        // This will get the images for default search string "kittens"
        imageViewModel.getFlickrPhotos()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //Making each page a section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imageViewModel.numberOfSections
    }
    //Making per page items as items in section
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageViewModel.getNumberOfRowsFor(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.ImagesCollectionViewCell,
                                                            for: indexPath) as? ImageCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        cell.updateCellWithDetails(photoURL: imageViewModel.getImageURLFor(section: indexPath.section, row: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Dividing the screen width into 3 cells with 10 points space between each cell including leading and trailing
        let width = (AppConstants.ScreenWidth - 40)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //LoadMore
        imageViewModel.loadMoreFor(section: indexPath.section, row: indexPath.row)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Setting search string in the model as it will provide search text to api call and clear the old data
        imageCollectionView.reloadData()
        imageViewModel.searchStr = searchBar.text ?? "kittens"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: NetworkHandler {
    func reloadData() {
        self.imageCollectionView.insertSections([self.imageCollectionView.numberOfSections])
    }
    
    func showFailureAlertWithMessage(message: String) {
        self.showAlert(title: "Error", messageBody: message, andActions: [UIAlertAction(title: "OK", style: .default)] )
    }
}
