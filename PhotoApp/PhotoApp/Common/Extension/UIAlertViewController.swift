//
//  UIAlertViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

extension UIAlertController {
    func confirmAlert(title: String, message: String) -> UIAlertController {
        let confirm = UIAlertController(title: title, message: message, preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        return confirm
    }
}
