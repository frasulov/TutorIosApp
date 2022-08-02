//
//  TutorCourseCell.swift
//  Tutor
//
//  Created by Fagan Rasulov on 02.08.22.
//

import UIKit

class TutorCourseCell: UITableViewCell {

    @IBOutlet weak var coursePrice: UILabel!
    @IBOutlet weak var courseLanguage: UILabel!
    @IBOutlet weak var courseSubCategory: UILabel!
    @IBOutlet weak var courseCategory: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
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
