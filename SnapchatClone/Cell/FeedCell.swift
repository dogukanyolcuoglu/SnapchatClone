//
//  FeedCell.swift
//  SnapchatClone
//
//  Created by Dogukan Yolcuoglu on 18.03.2021.
//

import UIKit

class FeedCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameCell: UILabel!
    @IBOutlet weak var imageviewCell: UIImageView!
    
    
    //MARK: - State funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
