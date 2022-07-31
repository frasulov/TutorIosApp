//
//  CategoryCell.swift
//  Tutor
//
//  Created by Fagan Rasulov on 27.07.22.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
