//
//  ViewController.swift
//  Fotos13
//
//  Created by Gary Hanson on 5/17/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit
import Photos


let backgroundColor = UIColor.systemGray5
let textColor = UIColor.systemGray

private extension Selector {
    static let onLoadedPhotosFromCameraRoll = #selector(ViewController.onLoadedPhotosFromCameraRoll)
}

final class ViewController: RootViewController, Storyboarded {
    @IBOutlet weak var dejaView: UIView!
    private var digestView = UIView()
    private var dejaVu: DejaViewController!
    private var dejaVuLabel = UILabel()
    private var cameraRoll: PhotosCollectionViewController!
    private var digest: DigestViewController!
    private var digestTitle = UILabel()
    private var safeArea = UIEdgeInsets()
    private var labelFont: UIFont!

    override func viewDidLoad() {
        super.viewDidLoad()

        // if nothing in the asset collection probably haven't asked user for permission
        // set callback for after user gives access to photos
        if Model.sharedInstance.assetCollection == nil {
            NotificationCenter.default.addObserver(self, selector: .onLoadedPhotosFromCameraRoll, name: .loadedPhotosFromCameraRoll, object: nil)
        }

        self.viewId = .digest
        dejaView.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = backgroundColor
        self.title = "Fotos 13"

        self.dejaVuLabel.textColor = textColor
        let localFont =  UIFont(name: "HelveticaNeue", size: 14.0)!
        self.labelFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: localFont)
        self.dejaVuLabel.font = self.labelFont
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: Date())
        self.dejaVuLabel.text = "Moments from \(month) ..."
        self.dejaVuLabel.backgroundColor = backgroundColor
        self.view.addSubview(self.dejaVuLabel)

        self.dejaVu = DejaViewController.instantiate()
        self.dejaVu.coordinator = self.coordinator

        self.addChild(self.dejaVu)
        self.dejaView.addSubview(self.dejaVu.view)
        self.dejaVu.didMove(toParent: self)

        self.loadDigest()
    }

    // user allowed access to photos so load them into our views
    @objc func onLoadedPhotosFromCameraRoll(_ notification: Notification) {
        self.dejaVu.layoutAndStart()
        self.digest.loadData()
    }

    private func loadDigest() {
        self.view.addSubview(self.digestView)
        self.digestTitle.textColor = textColor
        self.digestTitle.font = self.labelFont
        self.digestTitle.text = "Digest ..."
        self.digestTitle.backgroundColor = backgroundColor
        self.view.addSubview(digestTitle)

        self.digest = DigestViewController.instantiate()
        self.digest.coordinator = self.coordinator

        self.addChild(self.digest)
        self.digestView.addSubview(self.digest.view)
        self.digest.didMove(toParent: self)
    }

    private func layoutViews() {

        let dejaVuframe = CGRect(origin: CGPoint(x: 10, y: self.safeArea.top + 10.0), size: CGSize(width: self.view.bounds.width, height: 16.0))
        self.dejaVuLabel.frame = dejaVuframe

        self.dejaView.frame.origin = CGPoint(x: 0, y: self.safeArea.top + 26.0)
        self.dejaView.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height / 5.0)
        self.dejaVu.view.frame = self.dejaView.bounds

        self.layoutDigest()
    }

    private func layoutDigest() {
        let frame = CGRect(origin: CGPoint(x: 10, y: self.dejaView.frame.origin.y + self.dejaView.frame.height),
            size: CGSize(width: self.view.bounds.width, height: 16.0))
        self.digestTitle.frame = frame

        let digestViewInset: CGFloat = 10
        self.digestView.frame.origin.x = digestViewInset
        self.digestView.frame.origin.y = self.digestTitle.frame.origin.y + self.digestTitle.frame.height + 10
        self.digestView.frame.size = CGSize(width: self.view.bounds.width - (2 * digestViewInset),
            height: self.view.bounds.height - self.digestView.frame.origin.y - safeArea.bottom - 2)

        self.digest.view.frame = self.digestView.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.safeArea = self.view.safeAreaInsets
        if self.safeArea.top == 0 {
            self.safeArea.top = 64
        }

        self.layoutViews()
        if Model.sharedInstance.assetCollection != nil {
            self.dejaVu.layoutAndStart()
        }
    }

}
