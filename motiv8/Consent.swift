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

    let check = UserDefaults.standard
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkConsent()
        self.navigationController?.isNavigationBarHidden = true
        self.consent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func consent() {
        print("consent called")
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func checkConsent() {
        if check.bool(forKey: "completedConsent") != true {
            check.set(false, forKey: "completedConsent")
        }
    }

}

extension Consent : ORKTaskViewControllerDelegate {
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        taskViewController.dismiss(animated: true, completion: nil)
        
        switch reason {
        case ORKTaskViewControllerFinishReason.completed:
            
            check.set(true, forKey: "completedConsent")
            print("completed consent")
            //send to survey vc
            self.performSegue(withIdentifier: "ShowSurvey", sender:self)
            
        case ORKTaskViewControllerFinishReason.discarded:
            
            print("discarded consent")
            //start over
            self.consent()
            
        default:
            print("breaking from consent")
            break
        }
    }

}

