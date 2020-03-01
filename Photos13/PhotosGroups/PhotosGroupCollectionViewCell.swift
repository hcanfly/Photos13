//
//  CameraRollCollectionViewCell.swift
//  CameraRoll
//
//  Created by Gary on 6/9/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit
import Photos


final class PhotosGroupCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView(frame: CGRect.zero)
    private let mediaTypeIconView = UIImageView(frame: CGRect.zero)
    var assetIdentifier = ""
    
    func setImage(image: UIImage?) {
        self.imageView.image = image
    }
    
    func setMediaType(mediaType: PHAssetMediaType) {
        if mediaType == .video {
            self.mediaTypeIconView.alpha = 1.0
            self.mediaTypeIconView.image = UIImage(named: "PlayIcon")
        } else {
            self.mediaTypeIconView.image = nil
            self.mediaTypeIconView.alpha = 0.0
        }
    }
    
    override func layoutSubviews() {
        self.mediaTypeIconView.frame = self.bounds.insetBy(dx: self.bounds.width * 0.3, dy: self.bounds.height * 0.3)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        
        self.imageView.frame = self.bounds
        self.imageView.bounds = self.bounds
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.layer.masksToBounds = true
        self.contentView.addSubview(self.imageView)
        
        self.mediaTypeIconView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.mediaTypeIconView)
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
}
