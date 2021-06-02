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
    
    var humans: [Human] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBSegueAction func simulationSegueAction(_ coder: NSCoder, sender: Any?) -> SimulationViewController? {
        let groupSize = Int(groupSizeTextField.text!) ?? 0
        let infectionFactor = Int(infectionFactorTextField.text!) ?? 0
        let recalculationPeriod = Int(recalculationPeriodTextField.text!) ?? 0
        return SimulationViewController(coder: coder, groupSize: groupSize, infectionFactor: infectionFactor, recalculationPeriod: recalculationPeriod)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
