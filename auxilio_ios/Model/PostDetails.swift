//
//  PostDetails.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/30/22.
//

import Foundation
import UIKit

struct Post {
    static let collectionName = "Posts"
    static let title = "title"
    static let description = "description"
    static let amount = "amount"
    static let rate = "rate"
    static let startDate = "startDate"
    static let endDate = "endDate"
    static let images = "images"
    static let location = "location"
    static let taskType = "taskType"
    static let post_id = "post_id"
    static let privacyAccess = "privacyAccess"
    static let postStatus = "postStatus"
    static let postedBy = "postedBy"
    static let pickedBy = "pickedBy"
    static let imageURLs = "imageURLs"
}

class AllPosts {
    static var savedPosts = [String]()
    static var pickedPosts = [String]()
    static var createdPosts = [String]()
}

struct PostDetails : Hashable {
    
    var name: String                        // title of the post
    var description: String                 // description of the post
    var amount: Double                      // amount user wants to get for the good or pay for the service
    var rate: String                        // rate at which the user wants to pay the amount
    var startDate: String                   // start date of the job
    var endDate: String                     // end date of the job
    var images: [UIImage]                   // images linked to the post
    var location: String                    // address of the person where they want to meet the service provider
    var taskType: String                  // type of the task
    var post_id: String                     // unique identification number to differentiate each post
    var allowLocationContactAccess: Bool    // boolean value that allows access to personal information
    var postStatus: String              // current status of the post
    var postedBy: String              // user that posted the post
    var pickedBy: String?              // user that picked the post
    var imageURLs : [String]
    
    init() {
        self.name = ""
        self.description = ""
        self.amount = 0
        self.rate = ""
        self.startDate = ""
        self.endDate = ""
        self.images = []
        self.location = ""
        self.taskType = PostType.service.rawValue
        self.post_id = UUID().uuidString
        self.allowLocationContactAccess = false
        self.postStatus = PostStatus.drafted.rawValue
        self.postedBy = ""
        self.pickedBy = "none"
        self.imageURLs = []
    }
    
}
