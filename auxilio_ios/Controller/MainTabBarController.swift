//
//  MainTabBarController.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Post tab
        let createPost = CreatePostCVC()
        let navigateCreatePost = UINavigationController(rootViewController: createPost)
        let createPostBarItem = UITabBarItem(title: "Create Post", image: UIImage(systemName: "plus.square"), selectedImage: UIImage(systemName: "plus.square.fill"))
        createPost.tabBarItem = createPostBarItem
        
        // Job Feed tab
        let jobFeed = JobFeedVC()
        let navigateJobFeed = UINavigationController(rootViewController: jobFeed)
        let jobFeedBarItem = UITabBarItem(title: "Job Feed", image: UIImage(systemName: "rectangle.stack"), selectedImage: UIImage(systemName: "rectangle.stack.fill"))
        jobFeed.tabBarItem = jobFeedBarItem
        
        // Profile tab
        let profile = ProfileVC()
        let navigateProfile = UINavigationController(rootViewController: profile)
        let profileBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        profile.tabBarItem = profileBarItem
        
        
        self.viewControllers = [navigateCreatePost, navigateJobFeed, navigateProfile]
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .secondaryLabel
        self.selectedIndex = 1
    }
    
    // UITabBarControllerDelegate method
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//    }
//    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//    }
}
