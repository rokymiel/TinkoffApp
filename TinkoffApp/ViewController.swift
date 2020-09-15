//
//  ViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 15.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.logFunctionName(with: "View will appear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.logFunctionName(with: "View did appear")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //view.
        Logger.logFunctionName(with: "View will layout subviews")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Logger.logFunctionName(with: "View did layout subviews")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.logFunctionName(with: "View will disappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Logger.logFunctionName(with: "View did disappear")
    }

}

