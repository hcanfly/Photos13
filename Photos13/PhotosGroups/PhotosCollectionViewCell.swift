//
//  PhotosViewCell.swift
//  Fotos5
//
//  Created by Gary on 6/9/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit
import Photos


final class PhotosCollectionViewCell: UICollectionViewCell {
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
        self.imageView.frame = self.bounds
        self.imageView.bounds = self.bounds
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .white
        self.imageView.frame = self.bounds
        self.imageView.bounds = self.bounds
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.layer.masksToBounds = true
        self.contentView.addSubview(self.imageView)

        self.mediaTypeIconView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.mediaTypeIconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
}
