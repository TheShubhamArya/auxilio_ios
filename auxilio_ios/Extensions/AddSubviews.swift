//
//  AddSubviews.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit

extension UIView {
    public func addSubViews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
