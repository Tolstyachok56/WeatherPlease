//
//  NotificationTableViewCell.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        self.textLabel?.text = "10:00"
        self.textLabel?.textColor = .white
        self.textLabel?.font = self.textLabel?.font.withSize(50)
        
        self.detailTextLabel?.text = "Wednesday"
        self.detailTextLabel?.textColor = .white
        self.detailTextLabel?.font = self.detailTextLabel?.font.withSize(14)
        
        self.backgroundColor = .clear
    }

}
