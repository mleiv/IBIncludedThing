//
//  FourthController.swift
//  IBIncludedStoryboardDemo
//
//  Created by Emily Ivie on 2/20/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class FourthController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var sentValue: String = "None"
    
    @IBAction func shareWithSixth(sender: UIButton) {
        findChildViewControllerType(SixthController.self) { controller in
            controller.sentValue = self.textField.text ?? ""
        }
    }
    
    @IBAction func openSeventhPage(sender: UIButton) {
        parentViewController?.performSegueWithIdentifier("Push Seventh", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from Third: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
}
