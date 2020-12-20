//
//  MenuTableViewCell.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/8/20.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var labelMenu: UILabel!
    @IBOutlet weak var imageMenu: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: -8, right: 8))
    }
}
