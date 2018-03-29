//
//  NotificationsViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 31.01.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import UserNotifications

final class NotificationsViewController: UIViewController {
    
    //MARK: - Variables
    var notificationModel: WeatherNotifications = WeatherNotifications()
    let scheduler = Scheluler()
    
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduler.registerLocalNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationModel = WeatherNotifications()
        notificationsTableView.reloadData()
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        switchEditMode()
    }
    
    func switchEditMode() {
        notificationsTableView.isEditing = !notificationsTableView.isEditing
        
        if notificationsTableView.isEditing {
            editButton.title = "Done"
            addButton.isEnabled = false
            notificationsTableView.allowsSelection = true
        } else {
            editButton.title = "Edit"
            addButton.isEnabled = true
            notificationsTableView.allowsSelection = false
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddEditViewController {
            destination.hidesBottomBarWhenPushed = true
            
            if segue.identifier == Id.addSegueID {
                destination.navigationItem.title = "Add"
                destination.segueInfo = SegueInfo(currentCellIndex: notificationModel.count, editMode: false, isOn: true, repeatWeekdays: [], soundLabel: "deskBell", vibration: true)
            } else if segue.identifier == Id.editSegueID {
                destination.navigationItem.title = "Edit"
                destination.segueInfo = sender as! SegueInfo
            }
            destination.delegate = self
        }
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = notificationModel.count
        if numberOfRows == 0 {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationTableViewCell(style: .subtitle, reuseIdentifier: Id.notificationCellID)
        cell.configure(row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            for cell in tableView.visibleCells {
                let sw = cell.accessoryView as! UISwitch
                if sw.tag > index {
                    sw.tag -= 1
                }
            }
            notificationModel.notifications.remove(at: indexPath.row)
            scheduler.reSchedule()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let currentNotification = notificationModel.notifications[index]
        performSegue(withIdentifier: Id.editSegueID, sender: SegueInfo(currentCellIndex: index, editMode: true, isOn: currentNotification.isOn, repeatWeekdays: currentNotification.repeatWeekdays, soundLabel: currentNotification.soundLabel, vibration: currentNotification.vibration))
    }
    
}
