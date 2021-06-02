//
//  ParametersTableViewController.swift
//  VkTestApp
//
//  Created by Алексей Красиков on 02.06.2021.
//

import UIKit

class ParametersTableViewController: UITableViewController {
    
    @IBOutlet var groupSizeTextField: UITextField!
    @IBOutlet var infectionFactorTextField: UITextField!
    @IBOutlet var recalculationPeriodTextField: UITextField!
    @IBOutlet var startSimulationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
