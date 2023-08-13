//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 12.08.2023.
//

import UIKit
import Photos


class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let cellID = "cellID"
    let headerID = "headerID"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .orange
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext))
        navigationController?.navigationBar.tintColor = .black
        
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        
        fetchPhotos()
    }
    
    var images = [UIImage]()
    
    fileprivate func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        allPhotos.enumerateObjects { asset, count, stop in
            
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 300, height: 300)
            let options = PHImageRequestOptions()
            options.isSynchronous
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, info in
                if let image = image {
                    self.images.append(image)
                }
                
                if count == allPhotos.count - 1 {
                    self.collectionView.reloadData()
                }
                
                
            }
            
            
            
            
        }
    }
    
    @objc fileprivate func handleCancel() {
        print("Cancelllll")
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleNext() {
        print("NEXTTTTT")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        let height = width
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)
        header.backgroundColor = .lightGray
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
        let photo = images[indexPath.item]
        cell.photoImageView.image = photo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-3) / 4
        let height = width
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    
}
