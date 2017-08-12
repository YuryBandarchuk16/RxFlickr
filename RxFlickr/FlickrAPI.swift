//
//  FlickrAPI.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 12/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import Foundation

struct FlickrAPI {
    public let API_KEY = "0296da77f778fa59a762e20dac58f082"
    public let API_SECRET = "0a2013ce63ed6270"
    
    func getPhotosByHashTagURL(hashtag: String) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&tags=\(hashtag)&format=json&nojsoncallback=1"
    }
    
    func buildImageURL(farm: Int, server: String, id: String, secret: String) -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_n.jpg"
    }
    
}
