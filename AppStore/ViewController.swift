//
//  ViewController.swift
//  AppStore
//
//  Created by Cường Nguyễn on 2019-02-28.
//  Copyright © 2019 Cường Nguyễn. All rights reserved.
//

import UIKit

class FeaturedAppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellId = "cellId"
    private let largeCellId = "largeCellId"
    private let headerId = "headerId"
    var featureApp: AppObject?
    var appCategories: [AppCategory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Feature Apps"
        //appCategories = AppCategory.sampleAppCategories()
        
//        AppCategory.fetchFeatureApps { (appCategories) in
//            self.appCategories = appCategories
//            self.collectionView?.reloadData()
//        }
        AppCategory.fetchFeatureApps { (appObject) in
            self.featureApp = appObject
            self.appCategories = self.featureApp?.categories
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        collectionView?.backgroundColor = .white
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellId)
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
    }
    
    func showDetailForApp(app: App) {
        let layout = UICollectionViewFlowLayout()
        let appDetailController = AppDetailController(collectionViewLayout: layout)
        appDetailController.app = app
        navigationController?.pushViewController(appDetailController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = appCategories?.count {
           return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! LargeCategoryCell
            cell.appCategory = appCategories?[indexPath.item]
            cell.featureAppController = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.appCategory = appCategories?[indexPath.item]
        cell.featureAppController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 {
            return CGSize(width: view.frame.width, height: 160)
        }
        return CGSize(width: view.frame.width, height: 230)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
        header.appCategory = featureApp?.bannerCategory
        return header
    }
}

class LargeCategoryCell: CategoryCell {
    
    private let largeAppCellId = "largeAppCellId"
    
    override func setupView() {
        super.setupView()
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeAppCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 32)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCellId, for: indexPath) as! AppCells
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
}

private class LargeAppCell: AppCells {
    fileprivate override func setupView() {
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[v0]-14-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
    }
}

class Header: CategoryCell {
    let cellId = "bannerCellId"
    
    override func setupView() {
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(appsCollectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))

    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2 + 50, height: frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCells
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
}

private class BannerCell: AppCells {
    fileprivate override func setupView() {
        addSubview(imageView)
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
    }
}

