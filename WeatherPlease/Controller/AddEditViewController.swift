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
    var delegate: NotificationsViewController!

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var settingsTableView: UITableView!
    
    var notificationModel: WeatherNotifications = WeatherNotifications()
    var segueInfo: SegueInfo!
    var vibrationIsOn: Bool = true
    var isOn: Bool!
    
    //MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        notificationModel = WeatherNotifications()
        settingsTableView.reloadData()
        vibrationIsOn = segueInfo.vibration
        configureTimePicker()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func configureTimePicker() {
        if segueInfo.editMode {
            timePicker.date = (notificationModel.notifications[segueInfo.currentCellIndex].date)
        } else {
            timePicker.date = Date()
        }
        timePicker.setValuesForKeys(["textColor": UIColor.white, "highlightsToday": false])
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        if segueInfo.editMode { delegate.switchEditMode() }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        var tempNotification = WeatherNotification()
        
        tempNotification.date = timePicker.date
        tempNotification.repeatWeekdays = segueInfo.repeatWeekdays
        tempNotification.soundLabel = segueInfo.soundLabel
        tempNotification.vibration = vibrationIsOn
        
        if segueInfo.editMode {
            notificationModel.notifications[segueInfo.currentCellIndex] = tempNotification
            delegate.switchEditMode()
        } else {
            notificationModel.notifications.append(tempNotification)
        }
        delegate.notificationsTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func vibrationSwitchPressed(_ sender: UISwitch) {
        vibrationIsOn = sender.isOn
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Id.weekdaysSegueID {
            if let destination = segue.destination as? WeekdaysViewController {
                destination.repeatWeekdays = segueInfo.repeatWeekdays
                destination.delegate = self
            }
        }
        if segue.identifier == Id.soundSegueID {
            if let destination = segue.destination as? SoundsViewController {
                destination.soundLabel = segueInfo.soundLabel
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
            cell = UITableViewCell(style: .value1, reuseIdentifier: Id.repeatReuseID)
            cell.textLabel?.text = "Repeat"
            cell.detailTextLabel?.text = WeekdaysViewController.repeatLabel(weekdays: segueInfo.repeatWeekdays)
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell = UITableViewCell(style: .value1, reuseIdentifier: Id.soundReuseID)
            cell.textLabel?.text = "Sound"
            cell.detailTextLabel?.text = segueInfo.soundLabel
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell = UITableViewCell(style: .default, reuseIdentifier: Id.vibrationReuseID)
            cell.textLabel?.text = "Vibration"
            let vibrationSwitch = UISwitch(frame: CGRect())
            vibrationSwitch.addTarget(self, action: #selector(vibrationSwitchPressed(_:)), for: .valueChanged)
            if vibrationIsOn {
                vibrationSwitch.setOn(true, animated: false)
            }
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
            performSegue(withIdentifier: Id.weekdaysSegueID, sender: nil)
        case 1:
            performSegue(withIdentifier: Id.soundSegueID, sender: nil)
        default:
            break
        }
    }
    
}


