//
//  FourthController.swift
//  IBIncludedThingDemo
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
    
    @IBAction func shareWithSixth(_ sender: UIButton) {
        find(controllerType: SixthController.self) { controller in
            controller.sentValue = self.textField.text ?? ""
        }
        //also would work: sixthIncludedThing.includedController as? SixthController 
    }
    
    @IBAction func openSeventhPage(_ sender: UIButton) {
        parent?.performSegue(withIdentifier: "Push Seventh", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from Third: \(!sentValue.isEmpty ? sentValue : "None")"
        textField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // option 1:
        sixthIncludedThing.includedController?.prepare(for: segue, sender: sender)
        // option 2:
//        let value = (sixthIncludedThing.includedController as? SixthController)?.textField?.text ?? ""
//        segue.destinationViewController.find(controllerType: SeventhController.self) { controller in
//            controller.sentValue = value
//        }
        // option 3:
        // Turn on the child view controller portion of IBIncludedThing prepareForSegue. See notes there for why it is turned off.
    }
    
}

extension FourthController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
