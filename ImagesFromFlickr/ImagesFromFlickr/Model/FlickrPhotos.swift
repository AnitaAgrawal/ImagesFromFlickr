//
//  FlickrPhotos.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation

class FlickrPhotos {
    var photos: [[PhotoDetails]] = []
    var page = 0
    var pages = 0
    var perpage = 30
    var total = 0
    
    func getRecentPhotos(completionHandler: @escaping (Bool)->Void) {
        ConnectionManager.makeHTTPRequest(url: APIEndPoints.GetRecent, queryParameters: [APIConstants.page: "\(page + 1)", APIConstants.per_page: "\(perpage)"], bodyParameters: [:], successHandler: { responseObject in
            print(responseObject)
            guard let photosObj = responseObject[APIConstants.photos] as? [String: Any] else {return completionHandler(false)}
            self.page = photosObj[APIConstants.page] as? Int ?? 0
            self.photos.append([])
            self.pages = photosObj[APIConstants.pages] as? Int ?? 0
            self.perpage = photosObj[APIConstants.perpage] as? Int ?? 30
            self.total = photosObj[APIConstants.total] as? Int ?? 0
            guard let photosArray = photosObj[APIConstants.photo] as? [[String:Any]] else {return completionHandler(false)}
            for photo in photosArray {
                let photoDetails = PhotoDetails(photoDetails: photo)
                self.photos[self.page - 1].append(photoDetails)
            }
             completionHandler(true)
        }) { (error) in
            print(error?.localizedDescription ?? "Error occurred")
             completionHandler(false)
        }
    }
}

struct PhotoDetails {
    var id = ""
    var owner = ""
    var secret = ""
    var server = ""
    var farm = 0
    var title = "title"
    var ispublic = true
    var isfriend = false
    var isfamily = false
    
    init(photoDetails: [String: Any]) {
        self.id = photoDetails[APIConstants.id] as? String ?? ""
        self.owner = photoDetails[APIConstants.owner] as? String ?? ""
        self.secret = photoDetails[APIConstants.secret] as? String ?? ""
        self.server = photoDetails[APIConstants.server] as? String ?? ""
        self.farm = photoDetails[APIConstants.farm] as? Int ?? 0
        self.title = photoDetails[APIConstants.title] as? String ?? ""
        self.ispublic = photoDetails[APIConstants.ispublic] as? Bool ?? true
        self.isfriend = photoDetails[APIConstants.isfriend] as? Bool ?? false
        self.isfamily = photoDetails[APIConstants.isfamily] as? Bool ?? false
    }
}
