//
//  AddAnnouncementViewController.swift
//  Beefficient
//
//  Created by Eugen on 11/06/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import UIKit
import Eureka

class AddAnnouncementViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section("Description")
            <<< TextRow(){ row in
                row.tag = "description"
                row.title = "Task description"
                row.placeholder = "Enter here"
            }
    }

}
