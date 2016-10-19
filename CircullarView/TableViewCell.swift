//
//  YouplusCell.swift
//  Youplus
//
//  Created by Astarta on 10/13/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var label = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.label.backgroundColor = UIColor.yellow
        self.contentView.addSubview(label)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 2)
    }

    
}
