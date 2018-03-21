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
    var notification: WeatherNotification!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with weatherNotification: WeatherNotification) {
        
        notification = weatherNotification
        
        configureLabel(self.textLabel!,
                       text: notification.formattedTime,
                       color: .white,
                       fontSize: 50)
        configureLabel(self.detailTextLabel!,
                       text: notification.formattedWeekdays,
                       color: .white,
                       fontSize: 14)
        self.backgroundColor = .clear
        
        notificationSwitch.isOn = notification.isOn
        notificationSwitch.addTarget(self, action: #selector(onOffSwitch), for: .valueChanged)
        self.accessoryView = notificationSwitch
    }
    
    @objc func onOffSwitch() {
        notification.isOn = !notification.isOn
    }
    
    private func configureLabel(_ label: UILabel, text: String, color: UIColor, fontSize: CGFloat) {
        label.text = text
        label.textColor = color
        label.font = label.font.withSize(fontSize)
    }

}
