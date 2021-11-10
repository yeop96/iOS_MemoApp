//
//  UIView+Extension.swift
//  MemoApp
//
//  Created by yeop on 2021/11/10.
//

import Foundation
import UIKit

extension UIView {
    
    //원하는 곳 둥구리
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    func addBottomBorderWithColor(color: UIColor) {
            let border = CALayer()
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 1)
            self.layer.addSublayer(border)
        }

    func addAboveTheBottomBorderWithColor(color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        self.layer.addSublayer(border)
    }
}
