//
//  UserDetails.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/30/22.
//

import Foundation
import UIKit

struct User {
    static let collectionName = "Users"
    static let name = "name"
    static let uuid = "uuid"
    static let email = "email"
    static let mobile = "mobile"
    static let address = "address"
    static let dob = "dob"
    static let postsCreated = "postsCreated"
    static let postsPicked = "postsPicked"
    static let postsSaved = "postsSaved"
    static let imageURL = "imageURL"
}

class UserDetails {

    var name: String = ""                        // name of the user
    var uuid: String = UUID().uuidString                       // unique identification string for each user
    var email: String = ""                   // email address of the user
    var mobile: String = ""                 // mobile number of the user
    var address: String = ""                // physical address of the user
    var dob: String = ""                     // date of birth of the user
    var postsCreated = [String]()           // lists of post uids created by user
    var postsPicked = [String]()            // lists of post uids picked by user
    var postsSaved = [String]()
    var imageURL = ""

//    @Persisted var profileImage: UIImage?              // stores users profile pictire
//    @Persisted private var personalInfo: PersonalInfo  // personal info structure that should not be visible to others
//    @Persisted var postedPost: [PostDetails]           // array of Posts that are posted by the User
//    @Persisted var pickedPost: [PostDetails]           // array of Posts that are picked by the User
//    @Persisted var savedPost: [PostDetails]            // array of Posts that are saved by the User
    
//    struct PersonalInfo {
//        var email: String                   // email address of the user
//        var mobile: String                  // mobile number of the user
//        var address: String                 // physical address of the user
//        var dob: Date                       // date of birth of the user
//    }
    
}
