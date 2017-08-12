//
//  Photo.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 07/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import Foundation
import Realm

final class Photo {
    dynamic var imageData: Data? = nil
    dynamic var title: String = ""
    dynamic var author: String = ""
    dynamic var description: String = ""
    
    init(imageData: Data?, title: String, author: String, description: String) {
        self.imageData = imageData
        self.title = title
        self.author = author
        self.description = description
    }
}
