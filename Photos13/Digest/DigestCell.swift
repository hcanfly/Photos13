//
//  DigestCell.swift
//  Fotos13
//
//  Created by Gary on 11/10/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit


final class DigestViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DigestViewCell"
    private let imageView = UIImageView(frame: CGRect.zero)

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }
    
    func setImage(_ image: UIImage?) {
        
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
    private func commonInit() {
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.masksToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.layer.borderWidth = 0.5
        //self.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
}
