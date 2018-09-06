//
//  ImageViewModel.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 06/09/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation

protocol NetworkHandler {
    func reloadData()
    func showFailureAlertWithMessage(message: String)
}

class ImageViewModel {
    private var flickrPhotos = FlickrPhotos()
    var delegate: NetworkHandler?
    var numberOfSections: Int {
        return flickrPhotos.photos.count
    }
    var searchStr: String = "kittens" {
        didSet {
            flickrPhotos.searchStr = searchStr
            getFlickrPhotos()
        }
    }
    
    func getNumberOfRowsFor(section: Int) -> Int {
        return flickrPhotos.photos[section].count
    }
    
    func getImageURLFor(section: Int, row: Int) -> String {
        return flickrPhotos.photos[section][row].getImageUrlString()
    }
    
    func loadMoreFor(section: Int, row: Int) {
        // Logic for pagination
        // let page = 1, perpage = 30, total = 10000
        //let section = 0, row = 21, photos.count = 30
        //if (1*30 < 10000) true
        //if (0*30 + 24 == (1*30 - 6)) true // we have only two more rows left, so get photos for another page
        if (flickrPhotos.page * flickrPhotos.perpage) < flickrPhotos.total {
            if ((section * flickrPhotos.perpage) + row == (flickrPhotos.photos.count * flickrPhotos.perpage) - 6) {
                getFlickrPhotos()
            }// We are not at the bottom of the collection view and still have many item to show to user.
        }//else we are at the end of the table and displayed all the availble images.
    }
    
    private func getFlickrPhotos() {
        flickrPhotos.getPhotos { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.delegate?.reloadData()
                }
            case .failure(let reason):
                var errorBody = ""
                switch reason {
                case .noInternetConnection:
                    errorBody = ErrorMessages.NoInternet
                case .dataFoundNil, .jsonSerializationFailed, .temporarilyUnavailable:
                    errorBody = ErrorMessages.Default
                case .internalServerError:
                    errorBody = ErrorMessages.NoInternet
                case .clientError:
                    errorBody = ErrorMessages.Client
                }
                self.delegate?.showFailureAlertWithMessage(message: errorBody)
            }
        }
    }
}

