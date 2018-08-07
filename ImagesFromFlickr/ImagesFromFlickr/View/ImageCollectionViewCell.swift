//
//  ImageCollectionViewCell.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var flickrImageView: UIImageView!
    
    func updateCellWithDetails(photoDetails: PhotoDetails) {
        flickrImageView.isHidden = true
        let urlStr = "https://farm\(photoDetails.farm).static.flickr.com/\(photoDetails.server)/\(photoDetails.id)_\(photoDetails.secret).jpg"
        flickrImageView.loadImageFrom(urlStr: urlStr)
    }
}
