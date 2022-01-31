//
//  CreatePostCVC.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/6/22.
//

import UIKit
import IQKeyboardManagerSwift

class CreatePostCVC: UIViewController {
    
    var collectionView : UICollectionView!
    let items = ["Information"]
    var imagePicker: UIImagePickerController!
    var selectedImage = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Post"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    private func taskTypeMenu() -> UIMenu? {
        let menu = UIMenu(title: "Task type", image: nil, identifier: nil, options: [], children: [
            UIAction(title: "Service", image: nil, handler: { [weak self] (_) in
                
            }),
            UIAction(title: "Goods", image: nil, handler: { [weak self] (_) in
                
            })
        ])
        return menu
    }
    
    private func imageAction() {
        let actionSheet = UIAlertController(title: "Select Images", message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.selectImage(from: .camera)
//            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//                print("jkhgjkljh")
//                self?.selectImage(from: .camera)
//                return
//            }
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.selectImage(from: .photoLibrary)
//            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
//                self?.selectImage(from: .photoLibrary)
//                return
//            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(camera)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(cancel)
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
          popoverPresentationController.sourceView = self.view
          popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverPresentationController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func selectImage(from source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func removeSelectedImage(_ sender: UIButton) {
        selectedImage.remove(at: sender.tag - 1)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

extension CreatePostCVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutDiffSection())
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.identifier)
        collectionView.register(TextViewCell.self, forCellWithReuseIdentifier: TextViewCell.identifier)
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.identifier)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(LabelButtonCell.self, forCellWithReuseIdentifier: LabelButtonCell.identifier)
        collectionView.register(SwitchCell.self, forCellWithReuseIdentifier: SwitchCell.identifier)
        collectionView.register(CreateButtonCell.self, forCellWithReuseIdentifier: CreateButtonCell.identifier)
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
        if section == 7 {return selectedImage.count + 1}
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 7 && indexPath.item == 0 {
            imageAction()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 || section == 2 || section == 3 || section == 8 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.identifier, for: indexPath) as? TextFieldCell else {return UICollectionViewCell()}
            cell.configure(with: indexPath)
            cell.textField.delegate = self
            return cell
        } else if section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCell.identifier, for: indexPath) as? TextViewCell else {return UICollectionViewCell()}
            return cell
        } else if section == 4 || section == 5{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as? DateCell else {return UICollectionViewCell()}
            cell.configure(with: indexPath)
            return cell
        } else if section == 6 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.identifier, for: indexPath) as? TextCell else {return UICollectionViewCell()}
            cell.configure(with: indexPath)
            return cell
        } else if section == 7 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {return UICollectionViewCell()}
            cell.removeImageButton.tag = indexPath.item
            cell.removeImageButton.addTarget(self, action: #selector(removeSelectedImage), for: .touchUpInside)
            if indexPath.item == 0 {
                cell.configure(with: indexPath, image: nil)
            } else {
                cell.configure(with: indexPath, image: selectedImage[indexPath.item-1])
            }
            return cell
        } else if section == 9 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelButtonCell.identifier, for: indexPath) as? LabelButtonCell else {return UICollectionViewCell()}
            cell.button.showsMenuAsPrimaryAction = true
            cell.button.menu = taskTypeMenu()
            return cell
        } else if section == 10 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell else { return UICollectionViewCell()}
            return cell
        } else if section == 11 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateButtonCell.identifier, for: indexPath) as? CreateButtonCell else {return UICollectionViewCell()}
            return cell
        }
        return UICollectionViewCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration()
//    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {

        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderWithTextView.identifier, for: indexPath) as? HeaderWithTextView else {return UICollectionReusableView()}
            headerView.configure(header: items[indexPath.section])
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
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)
            
            var groupHeight = NSCollectionLayoutDimension.absolute(50)
            var groupWidth =  NSCollectionLayoutDimension.fractionalWidth(1)
            
            if sectionIndex == 1 {
                groupHeight = NSCollectionLayoutDimension.absolute(110)
            } else if sectionIndex == 7 {
                columns = 4
                groupHeight = NSCollectionLayoutDimension.absolute(80)
            } else if sectionIndex == 11 {
                groupHeight = NSCollectionLayoutDimension.absolute(40)
            }
            
            if self.collectionView.frame.size.width > 500 || self.collectionView.frame.size.height > 1000{
                groupHeight = NSCollectionLayoutDimension.fractionalHeight(0.1)
                groupWidth = NSCollectionLayoutDimension.fractionalWidth(1)
                columns = 2
            }
            
            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth,
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            if sectionIndex == 0{
                let layoutSectionHeader = self.createSectionHeader(with: sectionIndex)
                section.boundarySupplementaryItems = [layoutSectionHeader]
            } else if sectionIndex == 7 {
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20)
            } else if sectionIndex == 11 {
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 20, trailing: 8)
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

extension CreatePostCVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreatePostCVC: UITextViewDelegate{
    
}

//MARK: - Delegate for image picker controller
extension CreatePostCVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            alert(title: "Error", message: "Image not found. Please try again.")
            return
        }
        
        selectedImage.append(image)
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
            
        }
    }
}
