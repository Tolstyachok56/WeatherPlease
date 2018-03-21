//
//  AddEditViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

final class AddEditViewController: UIViewController {
    
    //MARK: - Variables
    var notification: WeatherNotification!
    var delegate: NotificationsViewController!
    var editMode: Bool!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var settingsTableView: UITableView!
    
    var weekDays: [Int]!
    var soundLabel: String!
    let vibrationSwitch = UISwitch()
    
    var weekdaysLabel: String {
        var repeatWeekdays = ""
        let daysOfWeek = DateFormatter().weekdaySymbols
        for item in self.weekDays.sorted() {
            repeatWeekdays += "\(daysOfWeek![item-1]) "
        }
        return repeatWeekdays
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimePicker()
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        if editMode { delegate.switchEditMode() }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        notification.date = timePicker.date
        notification.repeatWeekdays = weekDays
        notification.soundLabel = soundLabel
        notification.vibration = vibrationSwitch.isOn
        
        if !editMode {
            delegate.notificationArray.append(notification)
        } else {
            delegate.switchEditMode()
        }
        
        delegate.notificationsTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureTimePicker() {
        timePicker.date = (notification?.date)!
        timePicker.setValuesForKeys(["textColor": UIColor.white, "highlightsToday": false])
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toWeekdays" {
            if let destination = segue.destination as? WeekdaysViewController {
                destination.repeatWeekdays = notification.repeatWeekdays
                destination.delegate = self
            }
        }
        if segue.identifier == "toSounds" {
            if let destination = segue.destination as? SoundsViewController {
                destination.soundLabel = notification.soundLabel
                destination.delegate = self
            }
        }
    }
    
}

extension AddEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        switch indexPath.row {
        case 0:
            cell = UITableViewCell(style: .value1, reuseIdentifier: "repeatCell")
            cell.textLabel?.text = "Repeat"
            cell.detailTextLabel?.text = weekdaysLabel
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell = UITableViewCell(style: .value1, reuseIdentifier: "soundCell")
            cell.textLabel?.text = "Sound"
            cell.detailTextLabel?.text = soundLabel
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell = UITableViewCell(style: .default, reuseIdentifier: "vibrationCell")
            cell.textLabel?.text = "Vibration"
            cell.accessoryView = vibrationSwitch
        default:
            break
        }
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        cell.backgroundColor = .clear
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toWeekdays", sender: nil)
        case 1:
            performSegue(withIdentifier: "toSounds", sender: nil)
        default:
            break
        }
    }
    
}


