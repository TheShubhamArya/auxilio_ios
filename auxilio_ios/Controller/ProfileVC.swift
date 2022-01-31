//
//  ProfileVC.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit

enum JobAction: Int {
    case posted
    case picked
}

class ProfileVC: UIViewController {
    
    var collectionView : UICollectionView!
    var segmentControl : UISegmentedControl!
    var segment = 0
    let items = ["Posted","Picked", "Saved"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupCollectionView()
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
    
    @objc func moveToSettings() {
        
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
            return 4
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCardCell.identifier, for: indexPath) as? ProfileCardCell else {return UICollectionViewCell()}
            cell.configure()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserJobPostingCell.identifier, for: indexPath) as? UserJobPostingCell else {return UICollectionViewCell()}
            cell.configureStatusLabel(at: indexPath)
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration()
//    }

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
            
            var groupHeight = sectionIndex == 0 ? NSCollectionLayoutDimension.fractionalHeight(0.25) : NSCollectionLayoutDimension.fractionalHeight(0.15)
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
            
//            if sectionIndex == 0 {
//                section.orthogonalScrollingBehavior = .groupPaging
//                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 8, bottom: 5, trailing: 8)
//            } else if sectionIndex == 4{
//                section.orthogonalScrollingBehavior = .groupPaging
//                let layoutSectionHeader = self.createSectionHeader(with: sectionIndex)
//                section.boundarySupplementaryItems = [layoutSectionHeader]
//                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
//            } else {
            if sectionIndex == 1{
                let layoutSectionHeader = self.createSectionHeader(with: sectionIndex)
                section.boundarySupplementaryItems = [layoutSectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            }
//            }
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


extension ProfileVC: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
            
    }
    
}
