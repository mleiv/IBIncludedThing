//
//  SecondController.swift
//  IBIncludedThingDemo
//
//  Created by Emily Ivie on 2/20/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class SecondController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var sentValue: String = "None"

    @IBAction func openThirdPage(_ sender: UIButton) {
        parent?.performSegue(withIdentifier: "Push Third", sender: sender)
    }
    
    @IBAction func openThirdPageAlt(_ sender: UIButton) {
        parent?.performSegue(withIdentifier: "Push Third (alternate with Storyboard reference)", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from First: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.findChildViewControllerType(ThirdController.self) { controller in
            controller.sentValue = self.textField?.text ?? ""
        }
    }
    
}
