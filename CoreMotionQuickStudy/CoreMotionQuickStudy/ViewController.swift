//
//  ViewController.swift
//  CoreMotionQuickStudy
//
//  Created by Rafael Galdino on 17/06/19.
//  Copyright © 2019 Rafael Galdino. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var canUIImageView: UIImageView!
    @IBOutlet weak var lblLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var actionUIButton: UIButton!
    
    var state : Int = 0
    var factor : Int = -1
    var percentage : Double = 0{
        didSet{
            self.percentLabel.text = String(self.percentage)
        }
    }
    
    let motion = CMMotionManager()
    var referenceAttitude:CMAttitude?
    var timer : Timer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        canUIImageView.transform = canUIImageView.transform.rotated(by: 15 * (CGFloat.pi/180))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch state {
        case 0:
            startAccelerometers()
//            lblLabel.text = "Spinning back"
            canUIImageView.transform = canUIImageView.transform.rotated(by: 10 * (CGFloat.pi/180))
            factor = (factor * -1)
        default:
            resetAll()
        }
    }
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let data = self.motion.accelerometerData {
                                    let y = data.acceleration.y
                                    // Use the accelerometer data in your app.
                                    if y > 0.6 && self.factor > 0{
                                        self.canUIImageView.transform = self.canUIImageView.transform.rotated(by: 10 * (CGFloat.pi/180))
                                        self.factor = -1
                                    }else if y < -3 && self.factor < 0{
                                        self.canUIImageView.transform = self.canUIImageView.transform.rotated(by: 10 * (CGFloat.pi/180))
                                        self.factor = 1
                                    }
                                    if atan2f(Float(self.canUIImageView.transform.b),Float(self.canUIImageView.transform.a)) == 0 {
                                        self.resetAll()
                                    }
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        }
    }
    
    @IBAction func resetPress(_ sender: Any) {
        resetAll()
    }
    
    
    func resetAll(){
        canUIImageView.transform = CGAffineTransform(rotationAngle: 15 * (CGFloat.pi/180))
        lblLabel.text = "Shake To Spin"
        percentLabel.text = "Touch To Begin"
        state = 0
        factor = -1
    }

}

