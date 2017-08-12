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
    
    public var realm: Realm!
    
    public var loadAll: Bool = false
    
    private let cellIndetifier = "photoCell"
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let dataLoader: DataLoader = DataLoader()
    private let photos: Variable<[Photo]> = Variable([])
    
    private var notificationToken: NotificationToken!
    private var changes: Int = 0
    
    // could be made as observable, but it is not necessary, because it receives value only once -
    // from previous view controller before segue
    public var hashTag: String! {
        didSet {
            self.dataLoader.getData(hashtag: self.hashTag, realm: realm).subscribe(onNext: {
                self.photos.value = $0
            }).disposed(by: self.disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photos"
        setupBackground()
        setupPhotosObserver()
        setupCellConfiguration()
        notificationToken = realm.addNotificationBlock { notification, realm in
            if self.changes <= 10 || self.changes % 10 == 0 {
                self.photos.value = Array(realm.objects(Photo.self))
            }
            self.changes += 1
        }
        if (loadAll) {
            photos.value = Array(realm.objects(Photo.self))
        }
        if (photos.value.count == 0 || loadAll == false) {
            photos.value.append(Photo(value: ["imageData": nil, "title": "Test Image", "author": "Nobody", "descriptionT": ""]))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    private func setupBackground() {
        let backgroundView: UIView = UIView()
        backgroundView.frame = self.tableView.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let backgroundImageView: UIImageView = UIImageView()
        backgroundImageView.frame = backgroundView.bounds
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        backgroundView.addSubview(backgroundImageView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundView.bounds
        backgroundView.addSubview(blurEffectView)
        
        self.tableView.backgroundView = backgroundView
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
            cell.layer.backgroundColor = UIColor.clear.cgColor
            return cell
        }.disposed(by: disposeBag)
        
        
        self.tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if (!(self != nil)) { return }
            let nextViewController = DetailsViewController(nibName: "DetailsViewController", bundle: bundle)
            nextViewController.photo = Variable(self!.photos.value[indexPath.row])
            nextViewController.realm = self!.realm
            self!.navigationController?.pushViewController(nextViewController, animated: true)
        }).addDisposableTo(disposeBag)
    }
    
    deinit {
        if notificationToken != nil {
            notificationToken.stop()
        }
    }

}
