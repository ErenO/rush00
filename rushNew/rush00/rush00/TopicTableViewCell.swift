//
//  TopicTableViewCell.swift
//  rush00
//
//  Created by Samuel TOUSSAY on 6/18/17.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {

	@IBOutlet weak var login: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var title: UITextView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
