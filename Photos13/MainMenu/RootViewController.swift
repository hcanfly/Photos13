//
//  RootViewController.swift
//  LCFotos
//
//  Created by Gary on 6/5/16.
//  Copyright © 2016 Gary Hanson. All rights reserved.
//

import UIKit



// base class for "root" controllers - ones that can be selected from the main menu
class RootViewController: UIViewController, MainMenuViewDelegate {

    var mainMenuViewController: MainMenuViewController?
    var viewId = ViewId.digest
    var mainMenuButton: UIBarButtonItem?
    weak var coordinator: AppCoordinator?


    override func viewDidLoad() {
        super.viewDidLoad()

        if self.mainMenuButton == nil {
            self.mainMenuButton = UIBarButtonItem(image: UIImage(named:"ic_menu"), style: .plain, target: self, action: Action.tappedMain)
        }

        self.navigationItem.setLeftBarButton(self.mainMenuButton, animated: true)
    }

    @objc func tappedMainMenu() {
        self.displayMainMenu(self, viewId: self.viewId, coordinator: coordinator)
    }
    
    private struct Action {
        static let tappedMain = #selector(tappedMainMenu)
    }

}
