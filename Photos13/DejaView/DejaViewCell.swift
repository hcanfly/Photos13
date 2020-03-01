//
//  DejaViewCell.swift
//  Fotos5
//
//  Created by Gary on 6/2/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit

final class DejaViewCell: UICollectionViewCell {

    private let imageView = UIImageView(frame: CGRect.zero)
    
    override func layoutSubviews() {
        self.imageView.frame = self.bounds
    }
    
    func setImage(image: UIImage?) {
        self.imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.masksToBounds = true
        self.contentView.addSubview(self.imageView)
    }
}
