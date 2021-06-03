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
    var healthyHumans: [Human] = [Human]()
    var infectedHumans: [Human] = [Human]()
    
    var timerForUpdateUI: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        createHealthyHumans()
        
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
    
    func createHealthyHumans() {
        for _ in 1...groupSize {
            healthyHumans.append(Human(x: Int.random(in: 20...Int(simulationView.frame.width) - 70), y: Int.random(in: 0...Int(simulationView.frame.height - 50))))
        }
    }
    
    func updateUI() {
        for subview in simulationView.subviews as [UIView]   {
          subview.removeFromSuperview()
        }
        
        healthyHumans.forEach { (human) in
            let smallFrame = CGRect(x: human.x, y: human.y, width: 50, height: 50)
            let square = UIView(frame: smallFrame)
            square.backgroundColor = .green
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            simulationView.addSubview(square)
            square.addGestureRecognizer(gesture)
        }
        
        infectedHumans.forEach { (human) in
            let smallFrame = CGRect(x: human.x, y: human.y, width: 50, height: 50)
            let square = UIView(frame: smallFrame)
            square.backgroundColor = .red
            simulationView.addSubview(square)
        }
        

        DispatchQueue.global(qos: .userInitiated).async {
            if !self.infectedHumans.isEmpty {
                for i in 0...self.infectedHumans.count - 1{
                    self.infectNearestHumans(infectedHuman: self.infectedHumans[i])
                    
                    if self.healthyHumans.isEmpty {
                        break
                    }
                }
            }
        }
        

        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.infectHumanByTap(x: Int(floor((sender?.view?.frame.origin.x)!)), y: Int(floor((sender?.view?.frame.origin.y)!)))
        sender?.view?.backgroundColor = .red
        
    }
    
    func infectHumanByTap(x: Int, y: Int) {
        
        if healthyHumans.count == 1 {
            infectedHumans.append(healthyHumans.first!)
            healthyHumans.remove(at: 0)
            healthyHumansLabel.text = String(Int(healthyHumansLabel.text!)! - 1)
            infectedHumansLabel.text = String(Int(infectedHumansLabel.text!)! + 1)
        } else {
            for i in 0...healthyHumans.count - 1 {
                if healthyHumans[i].x == x && healthyHumans[i].y == y {
                    infectedHumans.append(healthyHumans[i])
                    healthyHumans.remove(at: i)
                    healthyHumansLabel.text = String(Int(healthyHumansLabel.text!)! - 1)
                    infectedHumansLabel.text = String(Int(infectedHumansLabel.text!)! + 1)
                    infectNearestHumans(infectedHuman: infectedHumans.last!)
                    break
                }
            }
        }
    }
    
    func infectNearestHumans(infectedHuman: Human) {
        var lengths: [Double] = [Double]()
        
        for i in stride(from: 0, to: healthyHumans.count - 1, by: 1) {
            let length: Double = sqrt(Double((infectedHuman.x - healthyHumans[i].x) * (infectedHuman.x - healthyHumans[i].x) + (infectedHuman.y - healthyHumans[i].y) * (infectedHuman.y - healthyHumans[i].y)))
            lengths.append(length)
        }
        

        for _ in 0...infectionFactor - 1{
            
            if lengths.isEmpty{
                if !healthyHumans.isEmpty {
                    infectedHumans.append(healthyHumans[0])
                    healthyHumans.remove(at: 0)
                    
                    DispatchQueue.main.async {
                        self.healthyHumansLabel.text = String(Int(self.healthyHumansLabel.text!)! - 1)
                        self.infectedHumansLabel.text = String(Int(self.infectedHumansLabel.text!)! + 1)
                    }

                }
                break
            }
            
            let minLengthIndex = lengths.firstIndex(of: lengths.min()!)
            
            infectedHumans.append(healthyHumans[minLengthIndex!])
            healthyHumans.remove(at: minLengthIndex!)
            
            DispatchQueue.main.async {
                self.healthyHumansLabel.text = String(Int(self.healthyHumansLabel.text!)! - 1)
                self.infectedHumansLabel.text = String(Int(self.infectedHumansLabel.text!)! + 1)
            }
            lengths.remove(at: minLengthIndex!)
        }
        
    }
    


}
