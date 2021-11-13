//
//  UILabel+Extension.swift
//  MemoApp
//
//  Created by yeop on 2021/11/12.
//

import UIKit

extension UILabel {
    
    func highlight(searchText: String, color: UIColor) {
       guard let text = self.text else { return }
       do {
           let str = NSMutableAttributedString(string: text)
           let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
           
           for match in regex.matches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: text.utf16.count)) as [NSTextCheckingResult] {
               str.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: match.range)
           }
           self.attributedText = str
       } catch {
           print(error)
       }
        
    }
    
    func nohighlight(color: UIColor) {
       guard let text = self.text else { return }
       let str = NSMutableAttributedString(string: text)
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: text.count))
       self.attributedText = str
    }
}
