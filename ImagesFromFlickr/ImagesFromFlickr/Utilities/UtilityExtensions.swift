//
//  UtilityExtensions.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation
import UIKit

/**
 *This class loads image using image url,
 *either download from server
 *or get it from local cache.
 *if image is not there in cache, then it'll download the image from server and save it in cache for future use.
 */

extension UIImageView {
    func loadImageFrom(urlStr: String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        
        DispatchQueue.global().async {[weak self] in
            do {
                if let image = ImageHandler.getImageFromCache(imageName: urlStr) {
                    DispatchQueue.main.async {[weak self] in
                        self?.image = image
                        self?.isHidden = false
                    }
                }else {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {[weak self] in
                        guard let image = UIImage(data: data) else {return}
                        self?.image = image
                        ImageHandler.saveImageToCache(imageName: urlStr, image: image)
                        self?.isHidden = false
                    }
                }
            } catch  {
                print("Error occurred during image download")
            }
        }
    }
}

extension UIViewController {
    /**
     This funtion is used to display an alert on keyWindow.
     
     - parameter title : Alert title, pass nil for no title
     - parameter messate : Alert Message
     - parameter actions : An array containing all alert actions to be performed on the alert. Each action will have title, style and completion handler block if needed to execute when tapped on.
     */
    func showAlert(title : String?,
                          messageBody message : String,
                          andActions actions : [UIAlertAction]) -> Void {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for alertAction in actions {
                alert.addAction(alertAction)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
