//
//  NotificationTableViewCell.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    let notificationSwitch = UISwitch()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with weatherNotification: WeatherNotification, forRowAt indexPath: IndexPath) {
        
        configureLabel(self.textLabel!,
                       text: weatherNotification.formattedTime,
                       color: .white,
                       fontSize: 50)
        configureLabel(self.detailTextLabel!,
                       text: weatherNotification.formattedWeekdays,
                       color: .white,
                       fontSize: 14)
        self.backgroundColor = .clear
        
        notificationSwitch.isOn = weatherNotification.isOn
        notificationSwitch.tag = indexPath.row + 1
        self.accessoryView = notificationSwitch
    }
    
    private func configureLabel(_ label: UILabel, text: String, color: UIColor, fontSize: CGFloat) {
        label.text = text
        label.textColor = color
        label.font = label.font.withSize(fontSize)
    }

}
