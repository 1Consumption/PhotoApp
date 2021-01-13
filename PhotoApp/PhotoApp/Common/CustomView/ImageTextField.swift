//
//  ImageTextField.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/12.
//

import UIKit

@IBDesignable
final class ImageTextField: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: frame.height))
            leftView = paddingView
            leftViewMode = ViewMode.always
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
