//
//  MainMenuViewController.swift
//
//  Created by Edgar on 10/6/15.
//

import UIKit


let mainMenuWidth: CGFloat = 320.0
let mainMenuHeaderHeight: CGFloat = 120.0
let mainMenuFooterHeight: CGFloat = 64.0
let menuSelectionColor = UIColor(hex: 0xe7f7ff)


protocol MainMenuViewDelegate: AnyObject {
    var mainMenuViewController: MainMenuViewController? { get set }
    var viewId: ViewId { get set }
    
    func mainMenuView(_ mainMenuView: MainMenuViewController, didSelectRowAtIndexPath indexPath: IndexPath, forMenuItem menuItem: mainMenuItem)
    func mainMenuViewDidCancel(_ mainMenuView: MainMenuViewController)
}

public enum MainMenuItemStyle : Int {
    case plain
    case separator
    case miniSeparator
}

public enum ViewId : Int {
    case digest
    case photos
    case settings
}

struct mainMenuItem {
    var style: MainMenuItemStyle = MainMenuItemStyle.plain
    var title: String?
    var subTitle: String?
    var viewId: ViewId?
    var icon: UIImage?
    var selectedIcon: UIImage?
    var height: CGFloat = -1.0
    var tintColor = 0
}

private extension Selector {
    static let handlePan = #selector(MainMenuViewController.handlePan(_:))
}



//MARK: - Menu Controller
final class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: MainMenuViewDelegate?
    weak var coordinator: AppCoordinator?

    var viewId: ViewId?
    weak var parentController: UIViewController?

    private var menuItems = [mainMenuItem]()
    private var scrimView: UIView?
    private var headerView: UIView?
    private var tableView: UITableView?
    private var menuView: UIView?
    private let kCellHeight: CGFloat = 64.0
    private let kPlainCellIdentifier = "mainMenuPlainCell"
    private let kSeparatorCellIdentifier = "mainMenuSeparatorCell"
    private let kMiniSeparatorCellIdentifier = "mainMenuMiniSeparatorCell"
    private var usernameLabel: UILabel?
    private var itemCount = -1
    private var panStartPt: CGPoint?
    private var panOriginPt: CGPoint?
    private var isPanning = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Create a view to hold the menu.
        let menuBgFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let menuBgView = UIView(frame: menuBgFrame)
        self.view.addSubview(menuBgView)

        // Create a scrim to darken the background.
        self.scrimView = UIView(frame: menuBgFrame)
        if let scrimView = self.scrimView {
            scrimView.backgroundColor = LyveColors.darkScrim.color()
            scrimView.alpha = 0
            menuBgView.addSubview(scrimView)
        }

        // Setup the menu dimensions.
        let width: CGFloat = mainMenuWidth
        let height: CGFloat = self.view.frame.height
        let menuFrame = CGRect(x: -width, y: 0, width: width, height: height)

        // Build the menu starting with the background.
        self.menuView = UIView(frame: menuFrame)
        if let menuView = self.menuView {
            menuView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            menuView.layer.shadowColor = UIColor.black.cgColor
            menuView.layer.shadowOpacity = 0.2
            menuView.layer.shadowRadius = 4.0
            menuView.layer.shadowOffset = CGSize(width: 1, height: 0)
            menuBgView.addSubview(menuView)

            // Create the table view.
            let tableFrame = CGRect(x: 0, y: mainMenuHeaderHeight + 10, width: menuView.bounds.width, height: menuView.bounds.height - mainMenuHeaderHeight - mainMenuFooterHeight - 10)
            self.tableView = UITableView(frame: tableFrame, style: .plain)
            if let tableView = self.tableView {
                tableView.delegate = self
                tableView.dataSource = self
                tableView.isUserInteractionEnabled = true
                tableView.separatorStyle = .none
                tableView.clipsToBounds = false
                menuView.addSubview(tableView)

                tableView.register(MainMenuPlainCell.self, forCellReuseIdentifier: kPlainCellIdentifier)
                tableView.register(MainMenuSeparatorCell.self, forCellReuseIdentifier: kSeparatorCellIdentifier)
                tableView.register(MainMenuMiniSeparatorCell.self, forCellReuseIdentifier: kMiniSeparatorCellIdentifier)

                updateSelection()
            }

            self.createHeader(menuView.bounds)
        }

        // Setup the pan gesture.
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: .handlePan)
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.menuView!.addGestureRecognizer(panGesture)
    }

    func createHeader(_ frame: CGRect) {
        let headerFrame = CGRect(x: 0, y: 0, width: frame.width, height: mainMenuHeaderHeight)
        self.headerView = UIView(frame: headerFrame)
        if let headerView = self.headerView {
            headerView.clipsToBounds = true
            headerView.backgroundColor = UIColor.white
            self.menuView!.addSubview(headerView)

            // Create the cloud image.
            let cloudFrame = CGRect(x: 20, y: 40, width: 50, height: 50)
            let cloudImage = UIImage(named: "CloudLogo")
            let cloudImageView = UIImageView(image: cloudImage)
            cloudImageView.contentMode = .scaleAspectFit
            cloudImageView.frame = cloudFrame
            cloudImageView.isUserInteractionEnabled = true
            headerView.addSubview(cloudImageView)

            let separatorView = UIView(frame: CGRect(x: 15, y: headerFrame.height - 1, width: headerFrame.width - 30, height: 0.5))
            separatorView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
            headerView.addSubview(separatorView)
        }
    }

    private func updateLayouts() {
        if let scrimView = self.scrimView {
            let menuBgFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            scrimView.frame = menuBgFrame
        }

        if let menuView = self.menuView {
            let width: CGFloat = mainMenuWidth
            let height: CGFloat = self.view.frame.height
            menuView.frame = CGRect(x: 0, y: 0, width: width, height: height)

            if let tableView = self.tableView {
                let tableFrame = CGRect(x: 0, y: mainMenuHeaderHeight + 10, width: menuView.bounds.width, height: menuView.bounds.height - mainMenuHeaderHeight - mainMenuFooterHeight - 10)
                tableView.frame = tableFrame
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showMenuAnimated(true, completion: {})
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.updateLayouts()
            }) { _ in
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches {
            let pos = touch.location(in: self.menuView)
            if !self.menuView!.bounds.contains(pos) {
                hideMenuAnimated(true, completion: {
                    if let delegate = self.delegate {
                        delegate.mainMenuViewDidCancel(self)
                    }
                })
                break
            }
        }
    }

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let pt = gestureRecognizer.translation(in: self.menuView!)

        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            self.panStartPt = pt
            panBegin()
        } else if gestureRecognizer.state == UIGestureRecognizer.State.changed {
            panWithOffset(CGPoint(x: pt.x - self.panStartPt!.x, y: pt.y - self.panStartPt!.y))
        } else if gestureRecognizer.state == UIGestureRecognizer.State.ended || gestureRecognizer.state == UIGestureRecognizer.State.cancelled {
            panEnd()
        }
    }

    func panBegin() {
        if self.isPanning {
            return
        }

        self.isPanning = true
        self.panOriginPt = self.menuView!.frame.origin
    }

    func panWithOffset(_ offset: CGPoint) {
        var x: CGFloat = self.panOriginPt!.x + offset.x
        x = min(0, x)

        self.menuView!.frame = CGRect(x: x, y: self.panOriginPt!.y, width: self.menuView!.frame.width, height: self.menuView!.frame.height)

        let percent: CGFloat = -x / self.menuView!.frame.width
        let alpha: CGFloat = 1.0 - pow(percent, 2)
        self.scrimView?.alpha = alpha
    }

    func panEnd() {
        if self.menuView!.frame.origin.x < -self.menuView!.frame.width * 0.3 {
            hideMenuAnimated(true, completion: {
                if let delegate = self.delegate {
                    delegate.mainMenuViewDidCancel(self)
                }
            })
        } else {
            showMenuAnimated(true, completion: {})
        }

        self.isPanning = false
    }

    func setViewId(_ viewId: ViewId) {
        self.viewId = viewId
    }

    private func updateSelection() {
        var row = 0
        for menuItem in self.menuItems {
            if menuItem.viewId == self.viewId {
                self.tableView!.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.top)
                break
            }
            row += 1
        }
    }

    private func showMenuAnimated(_ animated: Bool, completion: @escaping () -> Void) {
        let destFrame = CGRect(x: 0, y: 0, width: self.menuView!.frame.width, height: self.menuView!.frame.height)

        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.menuView!.frame = destFrame
                self.scrimView?.alpha = 1.0
                }, completion: { _ in
                    completion()
            })
        } else {
            self.scrimView?.alpha = 1.0
            self.menuView!.frame = destFrame
        }
    }

    private func hideMenuAnimated(_ animated: Bool, completion: @escaping () -> Void) {
        let destFrame = CGRect(x: -self.menuView!.frame.width, y: 0, width: self.menuView!.frame.width, height: self.menuView!.frame.height)

        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                self.menuView!.frame = destFrame
                self.scrimView?.alpha = 0.0
                }, completion: { _ in
                    self.menuView?.removeFromSuperview()
                    self.dismiss(animated: false, completion: {
                        completion()
                    })
            })
        } else {
            self.menuView!.frame = destFrame
            self.menuView?.removeFromSuperview()
            self.scrimView?.alpha = 0.0
            self.dismiss(animated: false, completion: {
                completion()
            })
        }
    }

    func appendMenuItem(_ menuItem: mainMenuItem) {
        self.menuItems.append(menuItem)
    }

}


// MARK: - UITableViewDataSource
extension MainMenuViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.menuItems.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = self.menuItems[indexPath.row]

        switch menuItem.style {
            case MainMenuItemStyle.plain:
                let cell: MainMenuPlainCell = tableView.dequeueReusableCell(withIdentifier: kPlainCellIdentifier)! as! MainMenuPlainCell

                cell.title!.text = menuItem.title
                cell.icon?.image = menuItem.icon?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.selectedIcon?.image = menuItem.selectedIcon?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell

            case MainMenuItemStyle.separator:
                let cell: MainMenuSeparatorCell = tableView.dequeueReusableCell(withIdentifier: kSeparatorCellIdentifier)! as! MainMenuSeparatorCell
                return cell

            case MainMenuItemStyle.miniSeparator:
                let cell: MainMenuMiniSeparatorCell = tableView.dequeueReusableCell(withIdentifier: kMiniSeparatorCellIdentifier)! as! MainMenuMiniSeparatorCell
                return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MainMenuViewController {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let menuItem = self.menuItems[indexPath.row]

        var height: CGFloat
        if menuItem.height == -1 {
            switch menuItem.style {
            case MainMenuItemStyle.plain:
                height = kCellHeight

            case MainMenuItemStyle.separator:
                height = 1.0

            case MainMenuItemStyle.miniSeparator:
                height = 1.0
            }
        } else {
            height = menuItem.height
        }

        return height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMenuAnimated(true, completion: {
            if let delegate = self.delegate {
                let menuItem = self.menuItems[indexPath.row]
                delegate.mainMenuView(self, didSelectRowAtIndexPath: indexPath, forMenuItem: menuItem)
            }
        })
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = menuSelectionColor
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }

}
