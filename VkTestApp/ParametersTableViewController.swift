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
    
    
    
    var groupSize: Int = Int()
    var infectionFactor: Int = Int()
    var recalculationPeriod: Int = Int()
    
    var humans: [Human] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateStartSimulationButton()
    }
    
    func updateStartSimulationButton() {
        groupSize = Int(groupSizeTextField.text!) ?? 0
        infectionFactor = Int(infectionFactorTextField.text!) ?? 0
        recalculationPeriod = Int(recalculationPeriodTextField.text!) ?? 0
        
        if groupSize == 0 || infectionFactor == 0 || recalculationPeriod == 0 {
            startSimulationButton.isEnabled = false
        } else {
            startSimulationButton.isEnabled = true
        }

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
