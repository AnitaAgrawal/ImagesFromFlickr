//
//  Utilities.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation
import UIKit

/**
 *This class holds all kinds of contants used through out the app.
 */

struct AppConstants {
    static let ScreenWidth = UIScreen.main.bounds.width
}

struct CellIdentifier {
    static let ImagesCollectionViewCell = "ImagesCollectionViewCellID"
}

struct APIConstants {
    static let photos = "photos"
    static let page = "page"
    static let pages = "pages"
    static let perpage = "perpage"
    static let total = "total"
    static let photo = "photo"
    static let id = "id"
    static let owner = "owner"
    static let secret = "secret"
    static let server = "server"
    static let farm = "farm"
    static let title = "title"
    static let ispublic = "ispublic"
    static let isfriend = "isfriend"
    static let isfamily = "isfamily"
    static let per_page = "per_page"
}

struct APIEndPoints {
    static let GetRecent = "flickr.photos.getRecent"
    static let Search = "flickr.photos.search"
}

struct APIKeys {
    static let ApiKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    static let BaseURL = "https://api.flickr.com/services/rest/?method="
}

struct ErrorMessages {
    static let NoInternet = "No internet. Please check your connection."
    static let Default = "Something went wrong. Please try again later."
    static let Server = "Internal server error. Please contact to administration."
    static let Client = "Something went wrong. Please check whether the details provided are correct."
}
