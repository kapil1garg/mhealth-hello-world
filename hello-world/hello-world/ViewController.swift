//
//  ViewController.swift
//  hello-world
//
//  Created by Kapil Garg on 1/21/16.
//  Copyright © 2016 Kapil Garg. All rights reserved.
//

import UIKit
import Parse
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var numberSteps: UILabel!
    @IBOutlet weak var thresholdText: UILabel!
    @IBOutlet weak var thresholdValue: UITextField!
    
    // create pedeometer object
    let pedoMeter = CMPedometer()
    
    // step threshold
    var stepThreshold = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default threshold to 1000 steps
        self.thresholdValue.text = String(stepThreshold)
        
        // create date objects used for selecting time
        let cal = NSCalendar.currentCalendar()
        let calendarComponents = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
        
        let timeZone = NSTimeZone.systemTimeZone()
        cal.timeZone = timeZone
        
        // set time to midnight (beginning of day)
        calendarComponents.hour = 0
        calendarComponents.minute = 0
        calendarComponents.second = 0
        
        let beginningOfDay = cal.dateFromComponents(calendarComponents)
        
        // begin step tracking
        if(CMPedometer.isStepCountingAvailable()) {
            self.pedoMeter.startPedometerUpdatesFromDate(beginningOfDay!, withHandler: { data, error in
                if (error == nil) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // post step value to parse
                        let newStepCount = PFObject(className: "pedometer_data")
                        newStepCount["steps"] = data?.numberOfSteps
                        newStepCount.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            print("Object has been saved.")
                        }
                        
                        // update number of steps on screen
                        self.numberSteps.text = "\(data!.numberOfSteps)"
                        
                        // set threshold text based on value
                        if (data?.numberOfSteps as! Int > self.stepThreshold) {
                            self.thresholdText.text = "World"
                        } else {
                            self.thresholdText.text = "Hello"
                        }
                    })
                }
            })
        }
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func setThreshold(sender: AnyObject) {
        // disable editing
        dismissKeyboard()
        
        // get string from field and convert to int if possible
        let newThreshold: String = thresholdValue.text!
        let newThresholdInt = Int(newThreshold)
        
        if (newThresholdInt != nil) {
            // set new threshold
            self.stepThreshold = newThresholdInt!
            
            // update threshold text
            let numberStepsInt = Int(self.numberSteps.text!)
            if (numberStepsInt > self.stepThreshold) {
                self.thresholdText.text = "World"
            } else {
                self.thresholdText.text = "Hello"
            }
        } else {
            // alert user that threshold value must be an integer
            let alertController = UIAlertController(title: "Invalid Threshold", message: "Threshold must be an integer", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                return true
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                return true
            }
        }
    }
}

