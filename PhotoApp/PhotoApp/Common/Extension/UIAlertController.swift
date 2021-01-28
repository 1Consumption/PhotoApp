//
//  UIAlertController.swift
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
    
    func showUseCaseErrorAlert(_ error: UseCaseError) {
        switch error {
        case .duplicatedRequest:
            break
        default:
            DispatchQueue.main.async { [weak self] in
                guard let alert = self?.confirmAlert(title: "에러 발생", message: error.message) else { return }
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
