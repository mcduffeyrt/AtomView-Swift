//
//  ViewController.swift
//  AtomView-Swift
//
//  Created by Richard McDuffey on 3/25/15.
//  Copyright (c) 2015 Richard McDuffey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let atom = AtomView()
        atom.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

