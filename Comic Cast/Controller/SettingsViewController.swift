//
//  SettingsViewController.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlet: Connection to View "storyboard"
    // -------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties: Array & Varables
    // -------------------------------------
    var settings = [Settings]()

    // MARK: - ViewDidLoad, ViewWillLoad etc...
    // ----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings = LocalService.instance.getSettings()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset.top = 45
    }
}

// MARK: - UITableView, Delegate & Datasource
// -----------------------------------------------
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hapticButton(.selection, lowPowerModeDisabled)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != 0 {
            if indexPath.row == 1 {
                // self.goToRegister(pageToLoadFirst: 1)
            } else if indexPath.row == 2 {
                // self.sendRequestAlert()
            } else if indexPath.row == 3 {
                print("instillinger")
                // self.goToSubSettings()
            } else if indexPath.row == 4 {
                // self.standardAlert()
            } else if indexPath.row == 5 {
                // self.logoutAlertActionSheet()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let settings = LocalService.instance.getSettings()
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as? SettingsTableViewCell {
            let settings = LocalService.instance.getSettings()
            let settingsRow = indexPath.row
            
            cell.setupView(settings: settings[settingsRow])
            return cell
        }
        return UITableViewCell()
    }
    
}
