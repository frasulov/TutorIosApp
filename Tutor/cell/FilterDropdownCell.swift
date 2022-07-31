//
//  FilterDropdownCell.swift
//  Tutor
//
//  Created by Fagan Rasulov on 26.07.22.
//

import UIKit

class FilterDropdownCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
