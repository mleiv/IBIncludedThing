//
//  ThirdController.swift
//  IBIncludedStoryboardDemo
//
//  Created by Emily Ivie on 2/20/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class ThirdController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var sentValue: String = "None"

    @IBAction func openFourthPage(sender: UIButton) {
        parentViewController?.performSegueWithIdentifier("Push Fourth", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from Second: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.findChildViewControllerType(FourthController.self) { controller in
            controller.sentValue = self.textField?.text ?? ""
        }
    }
    
}
