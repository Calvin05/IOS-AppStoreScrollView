//
//  CategoryCell.swift
//  AppStore
//
//  Created by Cường Nguyễn on 2019-02-28.
//  Copyright © 2019 Cường Nguyễn. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var featureAppController: FeaturedAppsController?
    var appCategory: AppCategory? {
        didSet {
            if let name = appCategory?.name {
                nameLabel.text = name
            }
            appsCollectionView.reloadData()
        }
    }
    private let cellId = "appCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel : UILabel = {
        let lb = UILabel()
        lb.text = "Best New Apps"
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(appsCollectionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(AppCells.self, forCellWithReuseIdentifier: cellId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(30)][v0][v1(0.5)]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView, "v1": dividerLineView, "nameLabel": nameLabel]))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count =  appCategory?.apps?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCells
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = appCategory?.apps?[indexPath.item] {
            featureAppController?.showDetailForApp(app: app)
        }
    }
    
}

class AppCells: UICollectionViewCell {
    var app: App? {
        didSet {
            if let name = app?.Name {
                label.text = name
                let rect = NSString(string: name).boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
                if rect.height > 20 {
                    category.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
                } else {
                    category.frame = CGRect(x: 0, y: frame.width + 22, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 40, width: frame.width, height: 20)
                }
                label.frame = CGRect(x: 0, y: frame.width + 5, width: frame.width, height: 40)
                label.sizeToFit()
            }
            
            category.text = app?.Category
            
            if let price = app?.Price {
                priceLabel.text = "$" + String(format:"%.2f", price)
            } else {
                priceLabel.text = ""
            }
            if let imageName = app?.ImageName {
                imageView.image = UIImage(named: imageName)
            }
            
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        //iv.image = UIImage(named: "image")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "Cute eyes in red"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.numberOfLines = 2
        return lb
    }()
    
    let category: UILabel = {
        let lb = UILabel()
        lb.text = "Entertainment"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = UIColor.darkGray
        lb.numberOfLines = 2
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "$3.99"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = UIColor.darkGray
        lb.numberOfLines = 2
        return lb
    }()
    
    func setupView() {
        addSubview(imageView)
        addSubview(label)
        addSubview(category)
        addSubview(priceLabel)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        label.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        category.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
        priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
    }
}

