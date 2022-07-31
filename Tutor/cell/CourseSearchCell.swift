//
//  CourseSearchCell.swift
//  Tutor
//
//  Created by Fagan Rasulov on 26.07.22.
//

import UIKit

class CourseSearchCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
