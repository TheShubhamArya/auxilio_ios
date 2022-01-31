//
//  TextFieldAttributes.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/24/22.
//

import UIKit

extension NSObject{
    func attributedPlaceholder(with text: String, for sfsymbol: String) -> NSMutableAttributedString {
        let fullString = NSMutableAttributedString(string: "")
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        let icon = NSTextAttachment()
        icon.image = UIImage(systemName: sfsymbol)?.withConfiguration(configuration).withTintColor(.secondaryLabel)
        fullString.append(NSAttributedString(attachment: icon))
        fullString.append(NSAttributedString(string: " " + text))
        return fullString
    }
}

