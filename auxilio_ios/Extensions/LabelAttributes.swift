//
//  LabelAttributes.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/24/22.
//

import UIKit

extension NSObject{
    func attributedAmount(with currency: String, for amount: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.boldSystemFont(ofSize: 13)
        ]
        let attributedString = NSMutableAttributedString(string: currency, attributes: attributes)
        attributedString.append(NSAttributedString(string: amount))
        return attributedString
    }
    
    func amountWithRatesAttributes(with currency: String, for amount: String, rate: String) -> NSMutableAttributedString {
        let currencyAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        let attributedString = NSMutableAttributedString(string: currency, attributes: currencyAttributes)
        
        let amountAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 30)
        ]
        
        let attributedString2 = NSMutableAttributedString(string: amount, attributes: amountAttributes)
        attributedString.append(attributedString2)
        
        let attributes3: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 20, weight: .thin)
        ]
        
        let attributedString3 = NSMutableAttributedString(string: rate, attributes: attributes3)
        attributedString.append(attributedString3)
        return attributedString
    }
}
