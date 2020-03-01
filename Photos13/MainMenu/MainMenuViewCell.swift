//
//  MainMenuViewCell.swift
//
//  Created by Edgar on 10/7/15.
//

import UIKit

final class MainMenuPlainCell: UITableViewCell {

    var icon: UIImageView?
    var selectedIcon: UIImageView?
    var title: UILabel?
    fileprivate let margin: CGFloat = 24
    fileprivate let gap: CGFloat = 24
    fileprivate let iconSize: CGFloat = 26
    fileprivate let defaultColor = LyveColors.selectedText.color()
    fileprivate let defaultSelectedColor = LyveColors.selectedDarkText.color()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear
        
        self.icon = UIImageView(frame: frame)
        self.icon?.contentMode = UIView.ContentMode.scaleAspectFit
        self.addSubview(self.icon!)

        self.selectedIcon = UIImageView(frame: frame)
        self.selectedIcon!.contentMode = UIView.ContentMode.scaleAspectFit
        self.selectedIcon!.isHidden = true
        self.addSubview(self.selectedIcon!)

        self.title = UILabel(frame: frame)
        self.title!.textAlignment = .left
        self.title!.font = LyveFont.light.font(17)
        self.title!.textColor = defaultColor
        self.addSubview(self.title!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.icon!.tintColor = selected ? defaultSelectedColor : defaultColor
        self.selectedIcon!.tintColor = self.icon!.tintColor
        self.icon!.isHidden = selected
        self.selectedIcon!.isHidden = !selected
        self.title!.textColor = selected ? defaultSelectedColor : defaultColor
        self.title!.font = selected ? LyveFont.medium.font(17) : LyveFont.light.font(17)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var iconFrame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        iconFrame = iconFrame.offsetBy(dx: self.margin, dy: (self.frame.height - iconFrame.height) / 2.0)
        self.icon!.frame = iconFrame
        self.selectedIcon!.frame = iconFrame

        let titleFrame = CGRect(x: iconFrame.maxX + gap, y: 0, width: self.frame.width - iconFrame.maxX - gap, height: self.frame.height)
        self.title!.frame = titleFrame
    }
}


class MainMenuSeparatorCell: UITableViewCell {

    fileprivate var separatorView: UIView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.separatorView = UIView(frame: frame)
        self.separatorView?.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        self.addSubview(self.separatorView!)
        self.isUserInteractionEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let separatorFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
        self.separatorView!.frame = separatorFrame
    }
}

final class MainMenuMiniSeparatorCell: MainMenuSeparatorCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.separatorView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let separatorFrame = CGRect(x: 16, y: 0, width: self.frame.width - 32, height: 1)
        self.separatorView!.frame = separatorFrame
    }
}


