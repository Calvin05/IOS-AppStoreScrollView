//
//  ScreenShotCell.swift
//  AppStore
//
//  Created by Cường Nguyễn on 2019-04-03.
//  Copyright © 2019 Cường Nguyễn. All rights reserved.
//

import UIKit

class ScreenShotCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var app: App? {
        didSet {
            collectionview.reloadData()
        }
    }
    
    var cellId = "cellId"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfCell = app?.Screenshots?.count {
            return numberOfCell
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenShotImageCell
        if let imageName = app?.Screenshots?[indexPath.item] {
            cell.imageView.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: frame.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    let collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupView() {
        super.setupView()
        
        collectionview.dataSource = self
        collectionview.delegate = self
        
        addSubview(collectionview)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionview)
        addConstraintsWithFormat(format: "V:|[v0][v1(1)]|", views: collectionview, dividerLineView)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        
        collectionview.register(ScreenShotImageCell.self, forCellWithReuseIdentifier: cellId)

    }
}

class ScreenShotImageCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .green
        return iv
    }()
    
    override func setupView() {
        super.setupView()
        
        layer.masksToBounds = true
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
    }
}
