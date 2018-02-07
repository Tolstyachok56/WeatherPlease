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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(time: Date, repeatWeekdays: String, isOn: Bool) {
        
        let time = convertDateToTime(date: time)
        configureLabel(self.textLabel!, text: time, color: .white, fontSize: 50)
        
        configureLabel(self.detailTextLabel!, text: repeatWeekdays, color: .white, fontSize: 14)
        
        self.backgroundColor = .clear
        
        let cellSwitch = UISwitch()
        cellSwitch.isOn = isOn
        self.accessoryView = cellSwitch
    }
    
    private func convertDateToTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: date)
    }
    
    private func configureLabel(_ label: UILabel, text: String, color: UIColor, fontSize: CGFloat) {
        label.text = text
        label.textColor = color
        label.font = label.font.withSize(fontSize)
    }

}
