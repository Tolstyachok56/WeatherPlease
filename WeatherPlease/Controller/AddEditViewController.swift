//
//  AddEditViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Notification", keyForSort: "date")
    var notification: WeatherNotification?
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if notification == nil {
            notification = WeatherNotification()
        }
        configureTimePicker()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func configureTimePicker() {
        timePicker.date = (notification?.date)!
        timePicker.setValuesForKeys(["textColor": UIColor.white, "highlightsToday": false])
    }
    
}

extension AddEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewTitle = self.navigationItem.title else {return 0}
        switch viewTitle {
        case "Edit":
            return 4
        case "Add":
            return 3
        default:
            return 0
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
            vibrationSwitch.isOn = (notification?.isOn)!
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
    
    //MARK: - UITableViewDelegate
    
    
}
