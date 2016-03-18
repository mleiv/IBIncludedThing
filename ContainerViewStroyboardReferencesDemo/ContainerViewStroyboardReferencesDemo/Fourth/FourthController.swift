//
//  FourthController.swift
//  ContainerViewStoryboardReferenceDemo
//
//  Created by Emily Ivie on 3/18/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class FourthController: UIViewController {
    // Note that we can't use a xib here like we did in IBIncludedThingDemo - it has to be a storyboard for container view/storyboard reference to use it.

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sixthIncludedThing: UIView! // note, can't reference containerview object or controller here, have to get via prepareforsegue
    weak var sixthController: SixthController?
    
    var sentValue: String = "None"
    
    @IBAction func shareWithSixth(sender: UIButton) {
        sixthController?.sentValue = self.textField.text ?? ""
    }
    
    @IBAction func openSeventhPage(sender: UIButton) {
        (parentViewController as? Flow2Controller)?.sentValue = sixthController?.textField.text
        parentViewController?.performSegueWithIdentifier("Push Seventh", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from Third: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // embed segues:
        if let controller = segue.destinationViewController as? SixthController {
            sixthController = controller
        }
    }
    
}
