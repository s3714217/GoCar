//
//  TableViewCell.swift
//  GoCar
//
//  Created by Thien Nguyen on 15/4/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var transaction: UILabel!
    @IBOutlet weak var carRego: UILabel!
    @IBOutlet weak var returnDate: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var carImg: UIImageView!
    
    @IBOutlet weak var carModel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
