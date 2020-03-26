//
//  DataFromFTRCell.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit

final class DataFromFTRCell: UITableViewCell {

    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var topLeft: UILabel!
    @IBOutlet weak var btmright: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var id = ""
}
