//
//  ItemCell.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-03.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var linkLabel: UILabel!
    
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = bodyFont
      
        
        let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        linkLabel.font = caption1Font
    }
    
}
