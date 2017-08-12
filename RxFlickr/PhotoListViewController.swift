//
//  PhotoListViewController.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 07/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

class PhotoListViewController: UITableViewController {
    
    private let cellIndetifier = "photoCell"
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let dataLoader: DataLoader = DataLoader()
    private let photos: Variable<[Photo]> = Variable([])
    
    public var hashTag: String! {
        didSet {
            var newPhotos: [Photo] = []
            DispatchQueue.global().async {
                self.dataLoader.getData(hashtag: self.hashTag).subscribe(onNext: {
                    newPhotos = $0
                }).disposed(by: self.disposeBag)
            }
            photos.value = newPhotos
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photos"
        setupPhotosObserver()
        setupCellConfiguration()
        photos.value.append(Photo(imageData: nil, title: "hello", author: "Vika", description: "!"))
    }
    
    private func setupPhotosObserver() {
        self.photos.asObservable()
            .subscribe(onNext: { photos in
                self.tableView.reloadData()
            }).addDisposableTo(disposeBag)
    }
    
    private func setupCellConfiguration() {
        tableView.dataSource = nil
        let bundle = Bundle(for: type(of: self))
        tableView.register(UINib(nibName: "PhotoCell", bundle: bundle), forCellReuseIdentifier: cellIndetifier)
        self.photos.asObservable().bind(to: self.tableView.rx.items) { (tableView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIndetifier, for: indexPath) as! PhotoCell
            cell.photo = element
            return cell
        }.disposed(by: disposeBag)
    }

}
