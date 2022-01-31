//
//  Double.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import Foundation

extension Double {
    
    var withCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var abbreviated: String {
        if self >= 1_000, self <= 999_999 {
            if self >= 1000 && self < 1_000_000 {
                return String(format: "%.0f", locale: Locale.current,self)
            }
            return String(format: "%.3fK", locale: Locale.current,self/1000)
        } else if self > 999_999 && self < 999_999_999 {
            return String(format: "%.3fM", locale: Locale.current,self/1_000_000)
        } else if self > 999_999_999 {
            return String(format: "%.3fB", locale: Locale.current,self/1_000_000_000)
        }
        
        return self.removeTrailingZeros
    }
    
    var abbreviateInCharts: String {
        if self >= 1_000, self <= 999_999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000)
        } else if self > 999_999 && self < 999_999_999 {
            return String(format: "%.1fM", locale: Locale.current,self/1_000_000)
        } else if self > 999_999_999 {
            return String(format: "%.1fB", locale: Locale.current,self/1_000_000_000)
        }
        
        return self.removeTrailingZeros
    }
    
    var removeTrailingZeros: String {
        var string = String(format : "%0.2f",self)
        
        while string.last == "0"{
            string.removeLast()
            if string.last == "."{
                string.removeLast()
                break
            }
        }
        return string
    }
    
    func removeTrailingZerosDouble()->Double{
        var string = String(format : "%0.2f",self)
        
        while string.last == "0"{
            string.removeLast()
            if string.last == "."{
                string.removeLast()
                break
            }
        }
        return Double(string) ?? 0.0
    }
}
