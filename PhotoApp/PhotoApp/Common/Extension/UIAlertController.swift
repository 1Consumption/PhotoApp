//
//  UIAlertController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

extension UIAlertController {
    
    static func confirmAlert(title: String, message: String) -> UIAlertController {
        let confirm = UIAlertController(title: title, message: message, preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        return confirm
    }
    
    static func showUseCaseErrorAlert(_ error: UseCaseError, presentor: UIViewController) {
        switch error {
        case .duplicatedRequest:
            break
        default:
            let alert = confirmAlert(title: "에러 발생", message: error.message)
            presentor.present(alert, animated: true, completion: nil)
        }
    }
}
