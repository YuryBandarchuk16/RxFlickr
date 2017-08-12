//
//  PhotoCell.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 12/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoCell: UITableViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var photo: Photo! {
        didSet {
            if let photoData = photo.imageData {
                photoImage.image = UIImage(data: photoData)
            } else {
                photoImage.image = UIImage(named: "no_photo")
            }
            photoImage.layer.borderWidth = 1.5
            photoImage.layer.borderColor = UIColor.white.cgColor
            titleLabel.text = "Title: \(photo.title)"
            authorLabel.text = "Owner: \(photo.author)"
            descriptionLabel.text = "Description: \(photo.descriptionT)"
        }
    }

}
