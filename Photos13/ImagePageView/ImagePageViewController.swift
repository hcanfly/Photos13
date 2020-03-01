//
//  ImagePageViewController.swift
//  Fotos13
//
//  Created by Gary on 6/5/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit
import Photos

final class ImagePageViewController: UIPageViewController, Storyboarded {
    weak var coordinator: AppCoordinator?
    var assets: [PHAsset]?

    var currentIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let viewController = viewFullScreenController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
    }
    
    private func viewFullScreenController(_ index: Int) -> ImageViewController? {
        if let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
                page.assetIndex = index
            page.asset = self.assets != nil ? self.assets![index] : Model.sharedInstance.assetCollection![index]
                return page
        }
        return nil
    }
}

//MARK: - UIPageViewControllerDataSource
extension ImagePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ImageViewController {
            let index = viewController.assetIndex
            if index > 0 {
                return viewFullScreenController(index - 1)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ImageViewController {
            let index = viewController.assetIndex
            if (index + 1) < (assets != nil ? assets!.count : Model.sharedInstance.assetCollection!.count) {
                return viewFullScreenController(index + 1)
            }
        }
        
        return nil
    }
    
    // MARK: - UIPageControl
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return Model.sharedInstance.assetCollection!.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }
}
