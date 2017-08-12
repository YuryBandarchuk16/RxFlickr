//
//  DataLoader.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 12/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import Foundation

struct DataLoader {
    
    let flickrAPI = FlickrAPI()
    let disposeBag = DisposeBag()
    let maxAttemptCount = 5
    
    func getData(hashtag: String, realm: Realm) -> Observable<[Photo]> {
        guard let url: URL = URL(string: flickrAPI.getPhotosByHashTagURL(hashtag: hashtag))
            else { return Observable.just([]) }
        let request: URLRequest = URLRequest(url: url)
        return URLSession.shared.rx.json(request: request).retry(maxAttemptCount)
            .map{ jsonResult in
                var resultData = [Photo]()
                if let allJson = jsonResult as? [String: AnyObject] {
                    if let photos = allJson["photos"] as? [String: AnyObject] {
                        if let photosArray = photos["photo"] as? [AnyObject] {
                            photosArray.forEach {
                                if let currentPhoto = $0 as? [String: AnyObject] {
                                    guard   let id = currentPhoto["id"] as? String,
                                            let owner = currentPhoto["owner"] as? String,
                                            let secret = currentPhoto["secret"] as? String,
                                            let server = currentPhoto["server"] as? String,
                                            let farm = currentPhoto["farm"] as? Int,
                                            var title = currentPhoto["title"] as? String
                                        else {
                                            return
                                    }
                                    var imageData: Data?
                                    if let imageURL = URL(string: self.flickrAPI.buildImageURL(farm: farm, server: server, id: id, secret: secret)) {
                                        imageData = try? Data(contentsOf: imageURL)
                                    }
                                    if title.isEmpty {
                                        title = "No title"
                                    }
                                    DispatchQueue.main.async {
                                        resultData.append(Photo(value: ["imageData": imageData as Any?, "title": title, "author": owner, "descriptionT": "", "hashtag": hashtag]))
                                        try? realm.write {
                                            realm.add(resultData.last!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                return resultData
        }
    }
}
