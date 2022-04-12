//
//  Alert.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/23/22.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
}
