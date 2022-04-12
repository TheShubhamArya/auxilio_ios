//
//  Enums.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/23/22.
//

import Foundation

enum ImageSource {
    case camera
    case photoLibrary
}

enum AuthType {
    case register
    case signin
}

enum JobAction: Int {
    case posted
    case picked
}

enum PostType : String {
    case good    = "Good"                       // things that can be bought or sold
    case service = "Service"                       // work done by a service provider
}

enum PostStatus: String {
    case completed = "Completed"         // the job is completed, no more work to be done
    case inProcess = "In process"        // post picked by someone, work in process, cannot be picked by another person
    case notPicked = "Not picked"        // post is not picked by anyone, still available to be picked
    case drafted  = "Drafted"           // post is still in draft and has not been posted yet
    case error  = "Error"               // some error in the post
}

enum UserPost : Int {
    case created = 0
    case picked
    case saved
}

enum Filter {
    case highToLow
    case lowToHigh
    case services
    case goods
    case all
}
