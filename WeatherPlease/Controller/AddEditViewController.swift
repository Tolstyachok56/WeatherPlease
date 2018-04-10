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
    private let scheduler = Scheduler()
    private var notificationModel: WeatherNotifications = WeatherNotifications()
    var segueInfo: SegueInfo!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var settingsTableView: UITableView!
    
    //MARK: - VC Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationModel = WeatherNotifications()
        settingsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimePicker()
    }
    
    //MARK: - Methods
    
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
        tempNotification.uuid = UUID().uuidString
        
        if segueInfo.editMode {
            notificationModel.notifications[segueInfo.currentCellIndex] = tempNotification
            delegate.switchEditMode()
        } else {
            notificationModel.notifications.append(tempNotification)
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
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segueInfo.editMode {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
        case 0:
            if row == 0 {
                cell = UITableViewCell(style: .value1, reuseIdentifier: Id.repeatReuseID)
                cell.textLabel?.text = "Repeat"
                cell.textLabel?.textColor = .white
                cell.detailTextLabel?.text = WeekdaysViewController.repeatLabel(weekdays: segueInfo.repeatWeekdays)
                cell.detailTextLabel?.textColor = .lightText
                cell.accessoryType = .disclosureIndicator
            } else if row == 1 {
                cell = UITableViewCell(style: .value1, reuseIdentifier: Id.soundReuseID)
                cell.textLabel?.text = "Sound"
                cell.textLabel?.textColor = .white
                cell.detailTextLabel?.text = segueInfo.soundLabel
                cell.detailTextLabel?.textColor = .lightText
                cell.accessoryType = .disclosureIndicator
            }
        case 1:
            cell = UITableViewCell(style: .default, reuseIdentifier: Id.deleteReuseID)
            cell.textLabel?.text = "Delete notification"
            cell.textLabel?.textColor = UIColor(red: 255/255, green: 200/255, blue: 0/255, alpha: 1)
            cell.textLabel?.textAlignment = .center
        default:
            break
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
        case 0:
            if row == 0 {
                performSegue(withIdentifier: Id.weekdaysSegueID, sender: nil)
            } else if row == 1 {
                performSegue(withIdentifier: Id.soundSegueID, sender: nil)
            }
        case 1:
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


