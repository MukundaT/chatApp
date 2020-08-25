//
//  MessageCell.swift
//  Flash Chat iOS13
//

//

import UIKit

class MessageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var MessageBubble: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var meAvatarImage: UIImageView!
    @IBOutlet weak var youAvatarImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
