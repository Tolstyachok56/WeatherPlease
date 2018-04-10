//
//  NotificationTableViewCell.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

final class NotificationTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureLabel(_ label: UILabel, text: String, color: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        label.text = text
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        
    }
    
    func configure(row: Int) {
        let weatherNotificationsModel = WeatherNotifications()
        let notification = weatherNotificationsModel.notifications[row]
        
        configureLabel(self.textLabel!, text: notification.formattedTime, color: .white, fontSize: 50, fontWeight: .light)
        configureLabel(self.detailTextLabel!, text: WeekdaysViewController.repeatLabel(weekdays: notification.repeatWeekdays), color: .white, fontSize: 14, fontWeight: .thin)
        
        let notificationSwitch = UISwitch(frame: CGRect())
        notificationSwitch.tag = row
        notificationSwitch.isOn = notification.isOn
        notificationSwitch.addTarget(self, action: #selector(onOffSwitchPressed(_:)), for: .valueChanged)
        self.accessoryView = notificationSwitch
        
        self.backgroundColor = .clear
    }
    
    @objc private func onOffSwitchPressed(_ sender: UISwitch) {
        let weatherNotificationsModel = WeatherNotifications()
        weatherNotificationsModel.notifications[sender.tag].isOn = sender.isOn
        let scheduler = Scheduler()
        scheduler.reSchedule()
    }
}
