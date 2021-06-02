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
    
    var groupSize: Int = Int()
    var infectionFactor: Int = Int()
    var recalculationPeriod: Int = Int()
    var humans: [Human] = [Human]()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        createHumans()
        drawHumans()
        
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
        for _ in 1...groupSize {
            humans.append(Human(x: Int.random(in: 0...Int(simulationView.frame.width)), y: Int.random(in: 0...Int(simulationView.frame.height))))
        }
    }
    
    func drawHumans() {
        humans.forEach { (human) in
            let smallFrame = CGRect(x: human.x, y: human.y, width: 50, height: 50)
            let square = UIView(frame: smallFrame)
            square.backgroundColor = .green
            
            simulationView.addSubview(square)
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
