//
//  ViewController.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 5/12/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import UIKit
import ResearchKit

class Consent: UIViewController {

    let check = NSUserDefaults.standardUserDefaults()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkConsent()
        self.navigationController?.navigationBarHidden = true
        self.consent()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func consent() {
        print("consent called")
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
    func checkConsent() {
        if check.boolForKey("completedConsent") != true {
            check.setBool(false, forKey: "completedConsent")
        }
    }

}

extension Consent : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        //Handle results with taskViewController.result
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        switch reason {
        case ORKTaskViewControllerFinishReason.Completed:
            
            check.setBool(true, forKey: "completedConsent")
            print("completed consent")
            //send to survey vc
            self.performSegueWithIdentifier("ShowSurvey", sender:self)
        
        case ORKTaskViewControllerFinishReason.Discarded:
            
            print("discarded consent")
            //start over
            self.consent()
            
        default:
            print("breaking from consent")
            break
        }
    }
}

