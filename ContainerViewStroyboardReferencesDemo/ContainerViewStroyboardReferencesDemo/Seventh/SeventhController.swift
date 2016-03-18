//
//  SeventhController.swift
//  ContainerViewStoryboardReferenceDemo
//
//  Created by Emily Ivie on 3/18/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class SeventhController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var sentValue: String = "None"

    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from Sixth: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
}
