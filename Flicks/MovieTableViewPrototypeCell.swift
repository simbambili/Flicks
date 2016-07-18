//
//  MovieTableViewPrototypeCell.swift
//  Flicks
//
//  Created by Shaz Rajput on 7/16/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit

class MovieTableViewPrototypeCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieSummaryLabel: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
