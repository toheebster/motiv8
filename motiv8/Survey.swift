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
        self.checkSurvey()
        self.navigationController?.navigationBarHidden = true
        self.survey()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func survey() {
        print("survey called")
        let taskVC = ORKTaskViewController(task: SurveyTask, taskRunUUID: nil)
        taskVC.delegate = self
        presentViewController(taskVC, animated: true, completion: nil)
    }
    
    func checkSurvey() {
        if check.boolForKey("completedSurvey") != true {
            check.setBool(false, forKey: "completedSurvey")
        }
    }
    
}

extension Survey : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        //Handle results with taskViewController.result
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        switch reason {
        case ORKTaskViewControllerFinishReason.Completed:
            
            check.setBool(true, forKey: "completedSurvey")
            print("completed survey")
            //send to survey vc
            self.performSegueWithIdentifier("ShowGoalsVC", sender:self)
        
        case ORKTaskViewControllerFinishReason.Discarded:
            
            print("discarded survey")
            let alert = UIAlertController(title: "Alert", message: "You must complete survey before continuing", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            
                //start over
                switch action.style {
                case .Default:
                    self.survey()
                default:
                    self.survey()
                }
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)

            
        default:
            print("breaking from survey")
            break
        }

        
    }
}