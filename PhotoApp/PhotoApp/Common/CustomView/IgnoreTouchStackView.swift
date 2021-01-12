//
//  IgnoreTouchStackView.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/12.
//

import UIKit

final class IgnoreTouchStackView: UIStackView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        guard self != hitView else { return nil }
        return hitView
    }
}
