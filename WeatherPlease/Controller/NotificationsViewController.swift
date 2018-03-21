//
//  NotificationsViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 31.01.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

final class NotificationsViewController: UIViewController {
    
    //MARK: - Variables
    var notificationArray = [WeatherNotification(date: Date(), isOn: false, repeatWeekdays: [4,5,6], vibration: true, soundLabel: "deskBell"),
                             WeatherNotification(date: Date(), isOn: true, repeatWeekdays: [1,2], vibration: false, soundLabel: "icyBell")]
    
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            if segue.identifier == "toAdd" {
                destination.navigationItem.title = "Add"
                destination.editMode = false
            } else if segue.identifier == "toEdit" {
                destination.navigationItem.title = "Edit"
                destination.editMode = true
            }
            
            if let notificationIndex = notificationsTableView.indexPathForSelectedRow?.row {
                destination.notification = notificationArray[notificationIndex]
            } else {
                destination.notification = WeatherNotification()
            }
            
            destination.weekDays = destination.notification.repeatWeekdays
            destination.soundLabel = destination.notification.soundLabel
            destination.vibrationSwitch.isOn = destination.notification.vibration
            destination.delegate = self
        }
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationTableViewCell(style: .subtitle, reuseIdentifier: "notificationCell")
        let notification = notificationArray[indexPath.row]
        cell.configure(with: notification)
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notificationArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
}
