//
//  ProfileVC.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit
import Firebase

class ProfileVC: UIViewController{
    
    var collectionView : UICollectionView!
    var segmentControl : UISegmentedControl!
    var segment = 0
    let items = ["Posted", "Picked", "Saved"]
    var user = UserDetails()
    var posts = [[PostDetails]](repeating: [PostDetails](), count: 3)
    var filteredPosts = [[PostDetails]](repeating: [PostDetails](), count: 3)
    let auth = Auth.auth()
    let db = Firestore.firestore()
    let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .gray
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupCollectionView()
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        accessCurrentUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if user.postsSaved != AllPosts.savedPosts || user.postsPicked != AllPosts.pickedPosts || user.postsCreated != AllPosts.createdPosts {
            activityIndicator.startAnimating()
            accessAllJobsRelatedToUser()
        }
        
    }
    
    func accessCurrentUserInfo() {
        let docRef = db.collection(User.collectionName).document(auth.currentUser!.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let name = data![User.name] as? String,
                   let mobile = data![User.mobile] as? String,
                   let email = data![User.email] as? String,
                   let address = data![User.address] as? String,
                   let dob = data![User.dob] as? String,
                   let postsCreated = data![User.postsCreated] as? [String],
                   let postsPicked = data![User.postsPicked] as? [String],
                   let postsSaved = data![User.postsSaved] as? [String],
                   let imageURL = data![User.imageURL] as? String{
                    self.user.name = name
                    self.user.mobile = mobile
                    self.user.email = email
                    self.user.address = address
                    self.user.dob = dob
                    self.user.postsCreated = postsCreated
                    self.user.postsPicked = postsPicked
                    self.user.postsSaved = postsSaved
                    self.user.imageURL = imageURL
                    if let url = URL(string: imageURL) {
                        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                            if let data = data, error == nil {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    if let image = UIImage(data: data) {
                                        self.user.image = image
                                    }
                                })
                            }
                        })
                        task.resume()
                    }
                    DispatchQueue.main.async {
                        self.accessAllJobsRelatedToUser()
                        self.collectionView.reloadData()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func accessAllJobsRelatedToUser() {
        db.collection(Post.collectionName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.posts[UserPost.created.rawValue] = []
                self.posts[UserPost.picked.rawValue] = []
                self.posts[UserPost.saved.rawValue] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if AllPosts.createdPosts.contains((data[Post.post_id] as? String)!) {
                        if let post = self.checkPostData(with: data) {
                            self.posts[UserPost.created.rawValue].append(post)
                        }
                        
                    } else if AllPosts.pickedPosts.contains((data[Post.post_id] as? String)!) {
                        if let post = self.checkPostData(with: data) {
                            self.posts[UserPost.picked.rawValue].append(post)
                        }
                        
                    }
                    if AllPosts.savedPosts.contains((data[Post.post_id] as? String)!) {
                        if let post = self.checkPostData(with: data) {
                            self.posts[UserPost.saved.rawValue].append(post)
                        }
                        
                    }
                }
                self.filteredPosts = self.posts
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func checkPostData(with data: [String : Any]) -> PostDetails? {
        var post = PostDetails()
        if let title = data[Post.title] as? String,
           let description = data[Post.description] as? String,
           let rate = data[Post.rate] as? String,
           let amount = data[Post.amount] as? Double,
           let startDate = data[Post.startDate] as? String,
           let endData = data[Post.endDate] as? String,
           let location = data[Post.location] as? String,
           let taskType = data[Post.taskType] as? String,
           let privacyAccess = data[Post.privacyAccess] as? Bool,
           let post_id = data[Post.post_id] as? String,
           let postedBy = data[Post.postedBy] as? String,
           let imageUrls = data[Post.imageURLs] as? [String],
           let pickedBy = data[Post.pickedBy] as? String,
           let postStatus = data[Post.postStatus] as? String{
            post.name = title
            post.description = description
            post.rate = rate
            post.amount = amount
            post.startDate = startDate
            post.endDate = endData
            post.location = location
            post.taskType = taskType
            post.allowLocationContactAccess = privacyAccess
            post.post_id = post_id
            post.postedBy = postedBy
            post.imageURLs = imageUrls
            post.pickedBy = pickedBy
            post.postStatus = postStatus
            if !post.imageURLs.isEmpty {
                if let url = URL(string: post.imageURLs.first!) {
                    if let data = try? Data(contentsOf: url) {
                        post.images.append(UIImage(data: data)!)
                        return post
                    }
                } else {
                    return post
                }
            } else {
                return post
            }
        }
        return nil
    }
    
    func setupNavbar(){
        self.title = "Profile"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        segmentControl = UISegmentedControl(items: items)
        segmentControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentControl
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(moveToSettings))
        navigationItem.rightBarButtonItem = settingButton
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "power"), style: .plain, target: self, action: #selector(logoutAction))
        navigationItem.leftBarButtonItem = logoutButton
        
        let searchController = UISearchController()
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search your jobs..."
        navigationItem.searchController = searchController
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .label
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        segment = segmentedControl.selectedSegmentIndex
        DispatchQueue.main.async { [weak self] in
//            self?.collectionView.setContentOffset(.zero, animated: false)
            self?.collectionView.reloadData()
        }
    }
    
    @objc func logoutAction() {
        let alertController = UIAlertController(title: "Log Out", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Log Out", style: .destructive, handler: {
            _ -> Void in
            do {
                try self.auth.signOut()
                DispatchQueue.main.async {
                    let vc = HomeVC()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true, completion: nil)
                }
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func moveToSettings() {
        
    }
    
    @objc func moveToEditProfileVC() {
        let vc = EditProfileVC()
        vc.editProfileDelegate = self
        vc.user = user
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ProfileVC : EditProfileDelegate {
    func didEditInfo(of user: UserDetails) {
        self.user = user
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutDiffSection())
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(ProfileCardCell.self, forCellWithReuseIdentifier: ProfileCardCell.identifier)
        collectionView.register(UserJobPostingCell.self, forCellWithReuseIdentifier: UserJobPostingCell.identifier)
        collectionView.register(HeaderWithTextView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderWithTextView.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return filteredPosts[segment].count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = JobDetailVC()
            vc.post = filteredPosts[segment][indexPath.item]
            vc.jobPickedDelegate = self
            vc.indexPath = indexPath
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCardCell.identifier, for: indexPath) as? ProfileCardCell else {return UICollectionViewCell()}
            cell.configure(with: user)
            cell.editButton.addTarget(self, action: #selector(moveToEditProfileVC), for: .touchUpInside)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserJobPostingCell.identifier, for: indexPath) as? UserJobPostingCell else {return UICollectionViewCell()}
            cell.configureStatusLabel(with: filteredPosts[segment][indexPath.item], isSaved: segment == 2 ? true : false)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderWithTextView.identifier, for: indexPath) as? HeaderWithTextView else {return UICollectionReusableView()}
            headerView.configure(header: "Jobs " + items[segment] + " by you")
            return headerView
            
            
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func createLayoutDiffSection() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var columns = 1
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7)
            
            var groupHeight = sectionIndex == 0 ? NSCollectionLayoutDimension.absolute(180) : NSCollectionLayoutDimension.absolute(120)
            var groupWidth =  NSCollectionLayoutDimension.fractionalWidth(1)
            
            if self.collectionView.frame.size.width > 500 || self.collectionView.frame.size.height > 1000{
                groupHeight = NSCollectionLayoutDimension.fractionalHeight(0.1)
                groupWidth = NSCollectionLayoutDimension.fractionalWidth(1)
                columns = 2
            }
            
            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth,
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            
            if sectionIndex == 1{
                let layoutSectionHeader = self.createSectionHeader(with: sectionIndex)
                section.boundarySupplementaryItems = [layoutSectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            }
            return section
        }
        return layout
    }
    
    private func createSectionHeader(with section: Int) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(35))

        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}

extension ProfileVC : JobPickedDelegate {
    func didPickJob(_ isPicked: Bool, removeFrom indexPath: IndexPath) {
        
    }
    
    func didChangePostStatus(for post: PostDetails,updateAt indexPath: IndexPath) {
        posts[segment][indexPath.item] = post
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


extension ProfileVC:  UISearchResultsUpdating, UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if !searchText.isEmpty {
            filteredPosts[segment] = posts[segment].filter({ (post) -> Bool in
                (post.name.lowercased().contains(searchText.lowercased())) ||
                (String(post.amount).contains(searchText)) ||
                (post.description.lowercased().contains(searchText.lowercased()))
            })
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        if searchText.isEmpty {
            filteredPosts = posts
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
}
