//
//  YouplusCell.swift
//  Youplus
//
//  Created by Astarta on 10/13/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var cellImageView = UIImageView()
    var nameLabel = UILabel()
    var priceLabel = UILabel()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.cellImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.priceLabel)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageViewHeight = self.bounds.height - Constants.bottonViewHeight - 10
        self.contentView.backgroundColor = .black
        
        self.cellImageView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: self.bounds.width,
                                      height: imageViewHeight)
        self.cellImageView.backgroundColor = .green
        self.imageView?.contentMode = .scaleAspectFill
        
        self.nameLabel.frame = CGRect(x: 10,
                                      y: imageViewHeight + 10,
                                      width: self.bounds.width / 2 - 10,
                                      height: Constants.bottonViewHeight)
        self.nameLabel.textColor = .white
        self.nameLabel.textAlignment = .left
        
        self.priceLabel.frame = CGRect(x: self.bounds.width / 2 + 10,
                                       y: imageViewHeight + 10,
                                       width: self.bounds.width / 2 - 20,
                                       height: Constants.bottonViewHeight)
        self.priceLabel.textColor = .white
        self.priceLabel.textAlignment = .right
    }

    
}

