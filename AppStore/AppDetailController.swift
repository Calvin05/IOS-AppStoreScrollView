//
//  AppDetailController.swift
//  AppStore
//
//  Created by Cường Nguyễn on 2019-03-25.
//  Copyright © 2019 Cường Nguyễn. All rights reserved.
//

import UIKit

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let headerId = "headerId"
    private let cellId = "cellId"
    private let descCellId = "descCellId"
    
    var app: App? {
        didSet {
            if app?.Screenshots != nil {
                return
            }
            
            if let id = app?.Id {
                let url = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
                let request = URLRequest(url: URL(string: url)!)
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if (error != nil) {
                        // couldn't get data from server
                        return
                    }
                    do {
                        let json: App = try JSONDecoder().decode(App.self, from: data!)
                        self.app = json
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    } catch _ {
                         // catch error here
                    }
                }.resume()
            }
        }
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(ScreenShotCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        header.app = app
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descCellId, for: indexPath) as! AppDetailDescriptionCell
            
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenShotCell
        cell.app = app
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            let size = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let option = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rec = descriptionAttributedText().boundingRect(with: size, options: option, context: nil)
            return CGSize(width: view.frame.width, height: rec.height + 30)
        }
        return CGSize(width: view.frame.width, height: 170)
    }
    
    private func descriptionAttributedText() -> NSAttributedString {
        let attributeText = NSMutableAttributedString(string: "Description\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let range = NSRange(location: 0, length: attributeText.string.count)
        attributeText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        if let desc = app?.description {
            attributeText.append(NSAttributedString(string: desc, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
        }
        
        return attributeText
    }
}

class AppDetailHeader: BaseCell {
    
    var app: App? {
        didSet {
            if let imageName = app?.ImageName {
                imageView.image = UIImage(named: imageName)
            }
            nameLabel.text = app?.Name
            
            if let price = app?.Price {
                buyButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = .darkGray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "TEST"
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    let buyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("BUY", for: .normal)
        btn.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return btn
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat(format: "H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-14-[v0(100)]", views: imageView)
        
        addConstraintsWithFormat(format: "V:|-14-[v0(20)]", views: nameLabel)
        
        addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithFormat(format: "V:[v0(34)]-8-|", views: segmentedControl)
        
        addConstraintsWithFormat(format: "H:[v0(60)]-14-|", views: buyButton)
        addConstraintsWithFormat(format: "V:[v0(30)]-54-|", views: buyButton)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(0.5)]|", views: dividerLineView)
    }
}

class AppDetailDescriptionCell: BaseCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE DESCRIPTION"
        return tv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(textView)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-[v1(1)]|", views: textView, dividerLineView)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDictionary))
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
}
