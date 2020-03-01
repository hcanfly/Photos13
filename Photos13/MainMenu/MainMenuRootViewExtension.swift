//
//  MainMenuRootViewExtension.swift
//
//  Created by Gary Hanson on 4/14/16.
//

import UIKit


extension RootViewController {
    
    func displayMainMenu(_ viewController: UIViewController, viewId: ViewId, coordinator: AppCoordinator?) {
        self.mainMenuViewController = MainMenuViewController()
        
        if let mainMenuViewController = self.mainMenuViewController {
            mainMenuViewController.delegate = self
            mainMenuViewController.coordinator = coordinator
            mainMenuViewController.parentController = viewController
            mainMenuViewController.setViewId(viewId)
            
            var menuItem = mainMenuItem()
            menuItem.title = "Digest".localized
            menuItem.viewId = .digest
            menuItem.icon = UIImage(named: "ic_file")
            menuItem.selectedIcon = UIImage(named: "ic_file_pressed")
            mainMenuViewController.appendMenuItem(menuItem)
            
            menuItem = mainMenuItem()
            menuItem.title = "Photos".localized
            menuItem.viewId = .photos
            menuItem.icon = UIImage(named: "icon-grid-view")
            menuItem.selectedIcon = UIImage(named: "icon-grid-view")
            mainMenuViewController.appendMenuItem(menuItem)
            
            menuItem = mainMenuItem()
            menuItem.title = "Settings".localized
            menuItem.viewId = ViewId.settings
            menuItem.icon = UIImage(named: "ic_settings")
            menuItem.selectedIcon = UIImage(named: "ic_settings_pressed")
            mainMenuViewController.appendMenuItem(menuItem)
            
            let navigationController = UINavigationController(rootViewController: mainMenuViewController)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(navigationController, animated: false, completion: nil)
        }
    }
    
    
    // MARK: - MainMenuViewDelegate
    
    func setViewId(_ viewId: ViewId) {

        switch viewId {
            case .digest:
                self.coordinator?.menuDidSelectContentPage()
            case .photos:
                self.coordinator?.menuDidSelectPhotosPage()
            case .settings:
                break
        }
    }
    
    func mainMenuView(_ mainMenuView: MainMenuViewController, didSelectRowAtIndexPath indexPath: IndexPath, forMenuItem menuItem: mainMenuItem) {
        if menuItem.viewId == mainMenuView.viewId {
            return
        }
        
        self.setViewId(menuItem.viewId!)
        self.mainMenuViewController = nil
    }
    
    func mainMenuViewDidCancel(_ mainMenuView: MainMenuViewController) {
        self.mainMenuViewController = nil
    }
    
}
