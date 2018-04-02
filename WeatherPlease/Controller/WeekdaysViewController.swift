//
//  WeekdaysViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 21.03.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

final class WeekdaysViewController: UIViewController {
    
    //MARK: - Variables
    var repeatWeekdays: [Int]!
    var delegate: AddEditViewController!

    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        delegate.segueInfo.repeatWeekdays = repeatWeekdays
        delegate.settingsTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension WeekdaysViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weekDays = DateFormatter().weekdaySymbols
        let cell = UITableViewCell()
        cell.textLabel?.text = weekDays?[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        if repeatWeekdays.contains(indexPath.row + 1) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if repeatWeekdays.contains(indexPath.row + 1) {
            cell?.accessoryType = .none
            let index = repeatWeekdays.index(of: indexPath.row + 1)
            repeatWeekdays.remove(at: index!)
        } else {
            cell?.accessoryType = .checkmark
            repeatWeekdays.append(indexPath.row + 1)
        }
        
    }
    
}

extension WeekdaysViewController {
    
    //MARK: - Static methods
    static func repeatLabel(weekdays: [Int]) -> String {
        if weekdays.count == 7 {
            return "Every day"
        }
        if weekdays.isEmpty {
            return ""
        }
        
        var ret = String()
        var weekdaysSorted:[Int] = [Int]()
        
        weekdaysSorted = weekdays.sorted(by: <)
        
        for day in weekdaysSorted {
            switch day{
            case 1:
                ret += "Sun "
            case 2:
                ret += "Mon "
            case 3:
                ret += "Tue "
            case 4:
                ret += "Wed "
            case 5:
                ret += "Thu "
            case 6:
                ret += "Fri "
            case 7:
                ret += "Sat "
            default:
                break
            }
        }
        return ret
    }
}
