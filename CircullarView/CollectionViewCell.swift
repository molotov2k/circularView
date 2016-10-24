//
//  CollectionViewCell.swift
//  Youplus
//
//  Created by Astarta on 10/14/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /* magic numbers, making imagesize smaller than cell size */
        self.imageView.frame = CGRect(x: 10, y: 7, width: self.bounds.width - 10, height: self.bounds.height - 13)
        self.imageView.contentMode = .scaleAspectFit
    }

    
}

