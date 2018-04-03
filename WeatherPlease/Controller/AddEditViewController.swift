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
    let scheduler = Scheduler()
    var notificationModel: WeatherNotifications = WeatherNotifications()
    var segueInfo: SegueInfo!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var settingsTableView: UITableView!
    
    //MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationModel = WeatherNotifications()
        settingsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimePicker()
    }
    
    
    private func configureTimePicker() {
        if segueInfo.editMode {
            timePicker.date = (notificationModel.notifications[segueInfo.currentCellIndex].date)
        } else {
            timePicker.date = Date()
        }
        timePicker.setValuesForKeys(["textColor": UIColor.white, "highlightsToday": false])
        timePicker.addTarget(self, action: #selector(changePickerValue), for: .valueChanged)
    }
    
    @objc func changePickerValue(sender: UIDatePicker) {
        print(sender.date)
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
        
        if segueInfo.editMode {
            notificationModel.notifications[segueInfo.currentCellIndex] = tempNotification
            delegate.switchEditMode()
        } else {
            notificationModel.notifications.append(tempNotification)
            print(notificationModel.notifications)
            print(WeatherNotifications().notifications)
        }
        scheduler.reSchedule()
        delegate.notificationsTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
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
        if segueInfo.editMode {
            return 3
        } else {
            return 2
        }
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
            cell = UITableViewCell(style: .default, reuseIdentifier: Id.deleteReuseID)
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
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: Id.weekdaysSegueID, sender: nil)
        case 1:
            performSegue(withIdentifier: Id.soundSegueID, sender: nil)
        case 2:
            notificationModel.notifications.remove(at: segueInfo.currentCellIndex)
            scheduler.reSchedule()
            delegate.switchEditMode()
            delegate.notificationsTableView.reloadData()
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
}


