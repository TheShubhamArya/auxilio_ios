//
//  HomeModel.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/5/22.
//

import Foundation
import UIKit

struct HomeModel {
    enum Section {
        case getStarted
        case benefits
        case customer
        case serviceProvider
        case aboutUs
    }
    
    var section : Section
    var header : String
    var subheader : String
    var image : String
}
