//
//  Survey.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 8/17/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit

class Survey: UIViewController {
    
    let check = NSUserDefaults.standardUserDefaults()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        self.survey()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func survey() {
        print("survey called")
        let taskVC = ORKTaskViewController(task: SurveyTask, taskRunUUID: nil)
        taskVC.delegate = self
        presentViewController(taskVC, animated: true, completion: nil)
    }
    
}

extension Survey : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        //Handle results with taskViewController.result
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        switch reason {
        case ORKTaskViewControllerFinishReason.Completed:
            check.setBool(true, forKey: "completedConsent")
            print("completed consent")
            //send to survey vc
            self.performSegueWithIdentifier("ShowGoalsVC", sender:self)
        default:
            print("breaking from survey")
            break
        }

        
    }
}