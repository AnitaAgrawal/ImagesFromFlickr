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
        let urlStr = "https://farm\(photoDetails.farm).static.flickr.com/\(photoDetails.server)/\(photoDetails.id)_\(photoDetails.secret).jpg"
        guard let url = URL(string: urlStr) else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            flickrImageView.image = UIImage(data: data)
        } catch  {
            print("Error occurred during image download")
        }
    }
}
