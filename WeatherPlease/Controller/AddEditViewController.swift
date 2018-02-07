//
//  AddEditViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Notification", keyForSort: "time")
    var viewTitle: String = ""
    var notification: WeatherNotification?
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = viewTitle
        timePicker.setValuesForKeys(["textColor": UIColor.white, "highlightsToday": false])
        print(timePicker)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        print("CANCEL")
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        print("SAVE")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewTitle {
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
            cell.detailTextLabel?.text = "Wednesday"
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell = UITableViewCell(style: .value1, reuseIdentifier: "soundCell")
            cell.textLabel?.text = "Sound"
            cell.detailTextLabel?.text = "Desk Bell"
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell = UITableViewCell(style: .default, reuseIdentifier: "vibrationCell")
            cell.textLabel?.text = "Vibration"
            cell.accessoryView = UISwitch()
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
