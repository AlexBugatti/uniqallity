//
//  UniqueCell.swift
//  Uniquality
//
//  Created by Александр on 20.11.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import UIKit

class UniqueCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var uniqLabel: UILabel! {
        didSet {
            self.uniqLabel.layer.cornerRadius = 4
            self.uniqLabel.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(uniq: Uniq) {
        self.titleLabel.text = uniq.title
        
        let uniqPercent = 100 - Int(uniq.percent * 100)
        
        if uniqPercent < 50 {
            self.uniqLabel.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else if uniqPercent >= 50 && uniqPercent < 85 {
            self.uniqLabel.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        } else {
            self.uniqLabel.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        self.uniqLabel.text = " \(uniqPercent)% "
    }
    
}
