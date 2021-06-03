//
//  SimulationViewController.swift
//  VkTestApp
//
//  Created by Алексей Красиков on 02.06.2021.
//

import UIKit

class SimulationViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var simulationView: UIView!
    
    @IBOutlet var healthyHumansLabel: UILabel!
    @IBOutlet var infectedHumansLabel: UILabel!
    
    
    var groupSize: Int = Int()
    var infectionFactor: Int = Int()
    var recalculationPeriod: Int = Int()
    var humans: [Human] = [Human]()
    var infectedHumans: [Human] = [Human]()
    
    var timerForUpdateUI: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        createHumans()
        
        healthyHumansLabel.text = String(groupSize)
        
        self.updateUI()
        timerForUpdateUI = Timer.scheduledTimer(withTimeInterval: Double(recalculationPeriod), repeats: true) { (timer) in
            self.updateUI()
        }
        timerForUpdateUI?.tolerance = 0.1
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return simulationView
    }
    
    func updateZoomFoor(size: CGSize) {
        let widthScale = size.width / simulationView.bounds.width
        let heightScale = size.height / simulationView.bounds.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0.0,
           usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
           options: [], animations: {
            self.updateZoomFoor(size: self.view.bounds.size)
        }, completion: nil)
        
    }
    
    init?(coder: NSCoder, groupSize: Int, infectionFactor: Int, recalculationPeriod: Int)
    {
        self.groupSize = groupSize
        self.infectionFactor = infectionFactor
        self.recalculationPeriod = recalculationPeriod
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createHumans() {
        for i in 1...groupSize {
            humans.append(Human(id: i-1, x: Int.random(in: 20...Int(simulationView.frame.width) - 70), y: Int.random(in: 0...Int(simulationView.frame.height - 50))))
        }
    }
    
    func updateUI() {
        for subview in simulationView.subviews as [UIView]   {
          subview.removeFromSuperview()
        }
        
        humans.forEach { (human) in
            let smallFrame = CGRect(x: human.x, y: human.y, width: 50, height: 50)
            let square = UIView(frame: smallFrame)
            square.backgroundColor = human.infected ? .red : .green
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            simulationView.addSubview(square)
            square.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        infectHumanByTap(x: Int(floor((sender?.view?.frame.origin.x)!)), y: Int(floor((sender?.view?.frame.origin.y)!)))
        sender?.view?.backgroundColor = .red
        
    }
    
    func infectHumanByTap(x: Int, y: Int) {
        for i in 0...humans.count - 1 {
            if humans[i].infected == false {
                if humans[i].x == x && humans[i].y == y {
                    humans[i].infected = true
                    healthyHumansLabel.text = String(Int(healthyHumansLabel.text!)! - 1)
                    infectedHumansLabel.text = String(Int(infectedHumansLabel.text!)! + 1)
                    infectNearestHuman(infectedHuman: humans[i])
                }
            }
        }
    }
    
    func infectNearestHuman(infectedHuman: Human) {
        var sortedHumans: [Human] = humans
        var sortedLength: [Double] = [Double]()
        for i in 0...humans.count - 1 {
            print("infectedHuman: (\(infectedHuman.x),\(infectedHuman.y))")
            print("New human: (\(humans[i].x),\(humans[i].y))")
            let length: Double = sqrt(Double((infectedHuman.x - humans[i].x) * (infectedHuman.x - humans[i].x) + (infectedHuman.y - humans[i].y) * (infectedHuman.y - humans[i].y)))
            print("Lenght: \(length)")
            sortedLength.append(length)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
