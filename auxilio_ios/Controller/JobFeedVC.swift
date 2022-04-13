//
//  TabTwoViewController.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit
import Firebase

class JobFeedVC: UIViewController {
    
    var collectionView : UICollectionView!
    let refreshControl = UIRefreshControl()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var allPosts = [PostDetails]()
    var filteredPosts = [PostDetails]()
    
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
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let docRef = db.collection(User.collectionName).document(auth.currentUser!.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                AllPosts.pickedPosts = data![User.postsPicked] as! [String]
                AllPosts.savedPosts = data![User.postsSaved] as! [String]
                AllPosts.createdPosts = data![User.postsCreated] as! [String]
                self.accessAllJobPostings()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func accessAllJobPostings() {
        activityIndicator.startAnimating()
        allPosts = []
        db.collection(Post.collectionName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    var post = PostDetails()
                    if ((data[Post.postedBy] as? String) != self.auth.currentUser?.uid) && (data[Post.pickedBy] as? String == "none") {
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
                                    DispatchQueue.global().async {
                                        if let data = try? Data(contentsOf: url) {
                                            post.images.append(UIImage(data: data)!)
                                            self.allPosts.append(post)
                                            self.filteredPosts = self.allPosts
                                        } else {
                                            self.allPosts.append(post)
                                            self.filteredPosts = self.allPosts
                                        }
                                        DispatchQueue.main.async {
                                            self.collectionView.reloadData()
                                        }
                                        
                                    }
                                } else {
                                    self.allPosts.append(post)
                                    self.filteredPosts = self.allPosts
                                }
                            } else {
                                self.allPosts.append(post)
                                self.filteredPosts = self.allPosts
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        accessAllJobPostings()
    }
    
    func setupNavbar() {
        self.title = "Job Feed"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let filterBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = filterBarButton
        
        let searchController = UISearchController()
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search jobs..."
        navigationItem.searchController = searchController
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .label
    }
    
    @objc func filterAction() {
        let actionSheet = UIAlertController(title: "Sort Posts", message: "", preferredStyle: .actionSheet)
        
        let highToLow = UIAlertAction(title: "High to low", style: .default) { [weak self] _ in
            self?.filterPosts(by: .highToLow)
        }
        
        let lowToHigh = UIAlertAction(title: "Low to high", style: .default) {[weak self] _ in
            self?.filterPosts(by: .lowToHigh)
        }
        
        let service = UIAlertAction(title: "Service", style: .default) {[weak self] _ in
            self?.filterPosts(by: .services)
        }
        
        let goods = UIAlertAction(title: "Goods", style: .default) {[weak self] _ in
            self?.filterPosts(by: .goods)
        }
        
        let all = UIAlertAction(title: "All jobs", style: .default) {[weak self] _ in
            self?.filterPosts(by: .all)
        }
        
        actionSheet.addAction(highToLow)
        actionSheet.addAction(lowToHigh)
        actionSheet.addAction(goods)
        actionSheet.addAction(service)
        actionSheet.addAction(all)
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
          popoverPresentationController.sourceView = self.view
          popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverPresentationController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filterPosts(by type: Filter) {
        switch type {
        case .highToLow:
            filteredPosts = allPosts.sorted(by: { post1, post2 in
                post1.amount > post2.amount
            })
        case .lowToHigh:
            filteredPosts = allPosts.sorted(by: { post1, post2 in
                post1.amount < post2.amount
            })
        case .services:
            filteredPosts = allPosts.filter({ posts in
                posts.taskType == PostType.service.rawValue
            })
        case .goods:
            filteredPosts = allPosts.filter({ posts in
                posts.taskType == PostType.good.rawValue
            })
        case .all:
            filteredPosts = allPosts
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

extension JobFeedVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutDiffSection())
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(JobPostingCell.self, forCellWithReuseIdentifier: JobPostingCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPosts.count//allPosts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = JobDetailVC()
        vc.post = filteredPosts[indexPath.item]
        vc.jobPickedDelegate = self
        vc.indexPath = indexPath
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostingCell.identifier, for: indexPath) as? JobPostingCell else {return UICollectionViewCell()}
            let post = filteredPosts[indexPath.item]//allPosts[indexPath.item]
            cell.configure(for: post, isSaved: AllPosts.savedPosts.contains(post.post_id))
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.section == 0 {
            return UIContextMenuConfiguration(identifier: "\(indexPath.row)" as NSString,previewProvider: nil) { _ in
                
                let saveAction = UIAction(title: "Save for later", image: UIImage(systemName: "heart")) { _ in
                    
                }
                let acceptAction = UIAction(title: "Accept Job", image: UIImage(systemName: "checkmark")) { _ in
                    
                }
                return UIMenu(title: "Quick Actions", image: nil, children: [saveAction, acceptAction])
            }
        }
        return UIContextMenuConfiguration()
    }
    
    func createLayoutDiffSection() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var columns = 1
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7)
            
            var groupHeight = NSCollectionLayoutDimension.absolute(120)
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
            
            let layoutSectionHeader = self.createSectionHeader(with: sectionIndex)
            section.boundarySupplementaryItems = [layoutSectionHeader]
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)

            return section
        }
        return layout
    }
    
    private func createSectionHeader(with section: Int) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(5))

        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}

extension JobFeedVC: JobPickedDelegate {
    func didChangePostStatus(for post: PostDetails, updateAt indexPath: IndexPath) {
        
    }
    
    func didPickJob(_ isPicked: Bool,removeFrom indexPath: IndexPath) {
        if isPicked {
            allPosts.remove(at: indexPath.item)
            filteredPosts = allPosts
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension JobFeedVC: UISearchResultsUpdating, UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if !searchText.isEmpty {
            filteredPosts = allPosts.filter({ (post) -> Bool in
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
            filteredPosts = allPosts
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
}
