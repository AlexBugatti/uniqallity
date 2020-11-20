//
//  NoteCell.swift
//  Uniquality
//
//  Created by Александр on 18.11.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = .disclosureIndicator
        // Initialization code
    }

    func configure(note: Note) {
        self.titleLabel.text = note.note
        self.authorLabel.text = note.username
    }
    
}
