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
    @IBOutlet weak var sixthIncludedThing: IBIncludedSubThing!
    
    var sentValue: String = "None"
    
    @IBAction func shareWithSixth(sender: UIButton) {
        findChildViewControllerType(SixthController.self) { controller in
            controller.sentValue = self.textField.text ?? ""
        }
        //also would work: sixthIncludedThing.includedController as? SixthController 
    }
    
    @IBAction func openSeventhPage(sender: UIButton) {
        parentViewController?.performSegueWithIdentifier("Push Seventh", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from Third: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // option 1:
        sixthIncludedThing.includedController?.prepareForSegue(segue, sender: sender)
        // option 2:
//        let value = (sixthIncludedThing.includedController as? SixthController)?.textField?.text ?? ""
//        segue.destinationViewController.findChildViewControllerType(SeventhController.self) { controller in
//            controller.sentValue = value
//        }
        // option 3:
        // Turn on the child view controller portion of IBIncludedThing prepareForSegue. See notes there for why it is turned off.
    }
    
}
