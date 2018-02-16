//
//  NotificationsViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 31.01.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
//import CoreData

final class NotificationsViewController: UIViewController {

    var notificationArray = [WeatherNotification(date: Date(), isOn: true, repeatWeekdays: [4,5,6], vibration: true, soundLabel: "deskBell"),
                             WeatherNotification(date: Date(), isOn: false, repeatWeekdays: [1,2], vibration: false, soundLabel: "icyBell")]
    
//    var fetchedResultController = CoreDataManager.instance.fetchedResultsController(entityName: "Notification", keyForSort: "date")
    
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        do {
//            try fetchedResultController.performFetch()
//        } catch {
//            print(error)
//        }
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
            
            if sender is WeatherNotification {
                destination.notification = sender as? WeatherNotification
            } else {
                destination.notification = WeatherNotification()
            }
            
            destination.delegate = self
            
            //TODO: - set/get data on/from add/edit view
        }
    }
    
    //MARK: - Action
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        notificationsTableView.isEditing = !notificationsTableView.isEditing
        
        if notificationsTableView.isEditing {
            editButton.title = "Done"
            notificationsTableView.allowsSelection = true
        } else {
            editButton.title = "Edit"
            notificationsTableView.allowsSelection = false
        }
    }
    

}
//MARK: -
extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
//        guard let sections = fetchedResultController.sections else {return 0}
//        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationTableViewCell(style: .subtitle, reuseIdentifier: "notificationCell")
        let notification = notificationArray[indexPath.row]
//        let notification = fetchedResultController.object(at: indexPath) as! WeatherNotification
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
        let notification = notificationArray[indexPath.row]
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: "toEdit", sender: notification)
    }
    
}
