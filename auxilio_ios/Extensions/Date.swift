//
//  Date.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 4/8/22.
//

import Foundation

extension Date {
    var fullDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL, yyyy 'at' h:mm a"
        let nameOfMonth = dateFormatter.string(from: self)
        return nameOfMonth
    }
}
