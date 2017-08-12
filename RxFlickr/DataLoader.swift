//
//  DataLoader.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 12/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

struct DataLoader {
    
    let flickrAPI = FlickrAPI()
    let disposeBag = DisposeBag()
    let maxAttemptCount = 5
    
    func getData(hashtag: String) -> Observable<[Photo]> {
        guard let url: URL = URL(string: flickrAPI.getPhotosByHashTagURL(hashtag: hashtag))
            else { return Observable.just([]) }
        let request: URLRequest = URLRequest(url: url)
        return URLSession.shared.rx.json(request: request).retry(maxAttemptCount)
            .map { jsonResult in
                var resultData = [Photo]()
                if let allJson = jsonResult as? [String: AnyObject] {
                    if let photos = allJson["photos"] as? [String: AnyObject] {
                        if let photosArray = photos["photo"] as? [AnyObject] {
                            photosArray.forEach {
                                if let currentPhoto = $0 as? [String: String] {
                                    guard   let id = currentPhoto["id"],
                                            let owner = currentPhoto["owner"],
                                            let secret = currentPhoto["secret"],
                                            let server = currentPhoto["server"],
                                            let farm = currentPhoto["farm"],
                                            let title = currentPhoto["title"]
                                        else {
                                            return
                                    }
                                    var imageData: Data?
                                    if let imageURL = URL(string: self.flickrAPI.buildImageURL(farm: farm, server: server, id: id, secret: secret)) {
                                        imageData = try? Data(contentsOf: imageURL)
                                    }
                                    resultData.append(Photo(imageData: imageData, title: title, author: owner, description: ""))
                                }
                            }
                        }
                    }
                }
                return resultData
        }
    }
}
