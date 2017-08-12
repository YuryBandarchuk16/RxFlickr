//
//  ViewController.swift
//  RxFlickr
//
//  Created by Юрий Бондарчук on 07/08/2017.
//  Copyright © 2017 Yury Bandarchuk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UITextFieldDelegate {
    
    private enum Segues: String {
        case searchPhotoByTag
    }
    
    private let disposeBag = DisposeBag()

    @IBOutlet weak var hashtagTextField: UITextField!
    @IBOutlet weak var seePhotosButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hashtagTextField.delegate = self
        seePhotosButton.rx.tap
            .subscribe(onNext: {
                if self.hashtagTextField.text == nil || self.hashtagTextField.text?.characters.count == 0 {
                    let alert = UIAlertController(title: "Empty hashtag!", message: "Enter the hashtag and press button again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
            }).addDisposableTo(disposeBag)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Segues.searchPhotoByTag.rawValue {
            guard let text = self.hashtagTextField.text
                else { return false; }
            return !text.isEmpty
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.searchPhotoByTag.rawValue {
            let destinationViewController = segue.destination as! PhotoListViewController
            destinationViewController.hashTag = hashtagTextField.text
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

