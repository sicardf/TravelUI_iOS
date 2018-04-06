//
//  ViewController.swift
//  NavitiaSDKUI-Example
//
//  Created by Flavien Sicard on 23/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import NavitiaSDKUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func touch(_ sender: Any) {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! JourneySolutionViewController
        
        journeyResultsViewController.inParameters = JourneySolutionViewController.InParameters(originId: "2.377092;48.846789", destinationId: "2.294685;48.884075")
        journeyResultsViewController.inParameters.originLabel = "Chez moi"
        journeyResultsViewController.inParameters.destinationLabel = "Au travail"
        journeyResultsViewController.inParameters.datetime = Date()
        journeyResultsViewController.inParameters.datetime!.addTimeInterval(2000)
        journeyResultsViewController.inParameters.datetimeRepresents = .departure
//        journeyResultsViewController.inParameters.forbiddenUris = ["physical_mode:Bus"]
//        journeyResultsViewController.inParameters.firstSectionModes = [.bss]
//        journeyResultsViewController.inParameters.lastSectionModes = [.car]
        journeyResultsViewController.inParameters.count = 20
        
        navigationController?.pushViewController(journeyResultsViewController, animated: true)
      //  self.present(UINavigationController(rootViewController: journeyResultsViewController), animated: true, completion: nil)
    }
    
    @IBAction func touchPresentView(_ sender: Any) {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! JourneySolutionViewController
        
        journeyResultsViewController.inParameters = JourneySolutionViewController.InParameters(originId: "2.377092;48.846789", destinationId: "2.294685;48.884075")
        journeyResultsViewController.inParameters.originLabel = "Chez moi"
        journeyResultsViewController.inParameters.destinationLabel = "Au travail"
        journeyResultsViewController.inParameters.datetime = Date()
        journeyResultsViewController.inParameters.datetime!.addTimeInterval(2000)
        journeyResultsViewController.inParameters.datetimeRepresents = .departure
        //        journeyResultsViewController.inParameters.forbiddenUris = ["physical_mode:Bus"]
        //        journeyResultsViewController.inParameters.firstSectionModes = [.bss]
        //        journeyResultsViewController.inParameters.lastSectionModes = [.car]
        journeyResultsViewController.inParameters.count = 20
        
          self.present(UINavigationController(rootViewController: journeyResultsViewController), animated: true, completion: nil)
    }
    
    
    
}


