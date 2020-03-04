//
//  OnboardingViewController.swift
//  Fotos5
//
//  Created by Gary on 5/18/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController, Storyboarded {
    weak var coordinator: AuthCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        for view in self.view.subviews {
            view.alpha = 1.0
        }
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    @IBAction func tappedOnboarding(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.view.subviews.forEach { $0.alpha = 0.1 }
        }, completion: { _ in
            self.coordinator?.didTapSignup(onBoardingVC: self)
        })
    }
    
}
