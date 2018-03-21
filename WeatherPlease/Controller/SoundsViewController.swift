//
//  SoundsViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 21.03.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class SoundsViewController: UIViewController {
    
    //MARK: - Variables
    let soundArray = ["deskBell", "icyBell", "slightBell"]
    
    var soundLabel: String!
    var delegate: AddEditViewController!

    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        delegate.soundLabel = soundLabel
        delegate.settingsTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }

}

extension SoundsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = soundArray[indexPath.row]
        
        cell.textLabel?.text = sound
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        
        if sound == self.soundLabel {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let checkedIndexPath = IndexPath(row: soundArray.index(of: soundLabel)!, section: 0)
        
        if checkedIndexPath == indexPath {
            return
        }
        
        let checkedCell = tableView.cellForRow(at: checkedIndexPath)
        checkedCell?.accessoryType = .none
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        soundLabel = soundArray[indexPath.row]
        
    }
    
}
