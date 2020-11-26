//
//  CustomSegue.swift
//  TinkoffApp
//
//  Created by Михаил on 26.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
class MyCustomSegue: UIStoryboardSegue {
    private var selfRetainer: MyCustomSegue?
    override func perform() {
        destination.transitioningDelegate = self
        selfRetainer = self
        destination.modalPresentationStyle = .popover
        source.present(destination, animated: true, completion: nil)
    }
}
extension MyCustomSegue: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyCustomTransition()
    }
    public func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            selfRetainer = nil
            return MyCustomDismisser()
    }
}
