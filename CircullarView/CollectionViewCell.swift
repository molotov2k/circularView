//
//  CollectionViewCell.swift
//  Youplus
//
//  Created by Astarta on 10/14/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var label = UILabel()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.label.textAlignment = .center
        self.contentView.addSubview(label)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }

    
}

