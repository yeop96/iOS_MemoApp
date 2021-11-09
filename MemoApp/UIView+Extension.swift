//
//  UIView+Extension.swift
//  MemoApp
//
//  Created by yeop on 2021/11/10.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
