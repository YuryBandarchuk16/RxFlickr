//
//  DetailsViewController.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 12/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class DetailsViewController: UIViewController {
    
    public var realm: Realm!
    private let disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public var photo: Variable<Photo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photo details"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            try? self.realm.write {
                self.photo.value.descriptionT.append("!")
            }
        }).addDisposableTo(disposeBag)
        
        photoImage.layer.borderWidth = 1.5
        photoImage.layer.borderColor = UIColor.white.cgColor
        setupPhotoObserver()
    }
    
    private func setupPhotoObserver() {
        photo.value.rx.observe(String.self, "descriptionT").subscribe(onNext: { _ in
            self.descriptionLabel.text = "Description: \(self.photo.value.descriptionT)"
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
        photo.asObservable().subscribe(onNext: { photo in
            if let photoData = photo.imageData {
                self.photoImage.image = UIImage(data: photoData)
            } else {
                self.photoImage.image = UIImage(named: "no_photo")
            }
            self.titleLabel.text = "Title: \(photo.title)"
            self.descriptionLabel.text = "Description: \(photo.descriptionT)"
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
