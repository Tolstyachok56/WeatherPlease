//
//  AddEditViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
//import CoreData

class AddEditViewController: UIViewController {
    
    var notification: WeatherNotification!
    var delegate: NotificationsViewController!
    var editMode: Bool!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimePicker()
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        //TODO: - Save data
        notification.date = timePicker.date
        
        if !editMode {
            delegate.notificationArray.append(notification)
        }
        
        delegate.notificationsTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureTimePicker() {
        timePicker.date = (notification?.date)!
        timePicker.addTarget(self, action: #selector(timePicked), for: .valueChanged)
        timePicker.setValuesForKeys(["textColor": UIColor.white, "highlightsToday": false])
    }
    
    @objc private func timePicked(picker: UIDatePicker) {
        if picker.isEqual(self.timePicker) {
            print(picker.date)
            notification.date = picker.date
            print(notification.formattedTime)
        }
    }
    
}

extension AddEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editMode {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        //TODO: - refactor
        switch indexPath.row {
        case 0:
            cell = UITableViewCell(style: .value1, reuseIdentifier: "repeatCell")
            cell.textLabel?.text = "Repeat"
            cell.detailTextLabel?.text = notification?.formattedWeekdays
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell = UITableViewCell(style: .value1, reuseIdentifier: "soundCell")
            cell.textLabel?.text = "Sound"
            cell.detailTextLabel?.text = notification?.soundLabel
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell = UITableViewCell(style: .default, reuseIdentifier: "vibrationCell")
            cell.textLabel?.text = "Vibration"
            let vibrationSwitch = UISwitch()
            vibrationSwitch.isOn = (notification?.vibration)!
            cell.accessoryView = vibrationSwitch
        case 3:
            cell = UITableViewCell(style: .default, reuseIdentifier: "deleteButton")
            cell.textLabel?.text = "Delete"
            cell.textLabel?.textAlignment = .center
        default:
            break
        }
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        cell.backgroundColor = .clear
        
        return cell
    }
    
}


