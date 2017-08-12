//
//  Photo.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 07/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

final class Photo: Object {
    dynamic var imageData: Data? = nil
    dynamic var title: String = ""
    dynamic var author: String = ""
    dynamic var descriptionT: String = ""
    dynamic var hashtag: String = ""
}
