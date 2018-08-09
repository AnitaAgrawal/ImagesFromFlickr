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
        flickrImageView.loadImageFrom(urlStr: photoDetails.getImageUrlString())
    }
}
