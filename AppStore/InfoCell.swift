//
//  InfoCell.swift
//  AppStore
//
//  Created by Cường Nguyễn on 2019-04-05.
//  Copyright © 2019 Cường Nguyễn. All rights reserved.
//

import UIKit

class InfoCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var app: App? {
        didSet {
        }
    }
    
    var cellId = "cellId"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = app?.appInformation?.count {
            return count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoViewCell
        return cell
    }
    
    override func setupView() {
        
        super.setupView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
}

class InfoViewCell: BaseCell {
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    let valueLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    override func setupView() {
        super.setupView()
    }
}

