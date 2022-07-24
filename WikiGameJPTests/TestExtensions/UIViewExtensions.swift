import UIKit

extension UIView {
    @objc public func findTableView() -> UITableView? {
        for subview in subviews where subview.isHidden == false {
            if let tableView = subview as? UITableView {
                return tableView
            }

            if let tableView = subview.findTableView() {
                return tableView
            }
        }

        return nil
    }

    @objc public func findCollectionView() -> UICollectionView? {
        for subview in subviews where subview.isHidden == false {
            if let collectionView = subview as? UICollectionView {
                return collectionView
            }

            if let collectionView = subview.findCollectionView() {
                return collectionView
            }
        }
        return nil
    }


    @objc public func findLabels(withExactText searchText: String) -> [UILabel] {
        var labels = [UILabel]()
        if let label = self as? UILabel, label.text == searchText {
            labels.append(label)
        }

        if let stackView = self as? UIStackView {
            for arrangedSubview in stackView.arrangedSubviews where arrangedSubview.isHidden == false {
                let arrangedSubviewLabels = arrangedSubview.findLabels(withExactText: searchText)
                labels.append(contentsOf: arrangedSubviewLabels)
            }
        }

        for subview in subviews where subview.isHidden == false {
            let subviewLabels = subview.findLabels(withExactText: searchText)
            labels.append(contentsOf: subviewLabels)
        }

        return labels
    }

    @objc public func findLabel(withExactText searchText: String) -> UILabel? {
        if let label = self as? UILabel, label.text == searchText {
            return label
        }

        if let stackView = self as? UIStackView {
            for arrangedSubview in stackView.arrangedSubviews where arrangedSubview.isHidden == false {
                if let label = arrangedSubview as? UILabel {
                    if label.text == searchText {
                        return label
                    }
                }

                if let label = arrangedSubview.findLabel(withExactText: searchText) {
                    return label
                }
            }
        }

        for subview in subviews where subview.isHidden == false {
            if let label = subview as? UILabel {
                if label.text == searchText {
                    return label
                }
            }

            if let label = subview.findLabel(withExactText: searchText) {
                return label
            }
        }
        return nil
    }

    @objc public func findLabel(withId text: String) -> UILabel? {
        if let label = self as? UILabel, label.accessibilityIdentifier == text {
            return label
        }

        for subview in subviews where subview.isHidden == false {
            if let label = self as? UILabel, label.accessibilityIdentifier == text {
                return label
            }

            if let label = subview.findLabel(withId: text) {
                return label
            }
        }

        return nil
    }

    @objc public func findLabel(containText searchText: String) -> UILabel? {
        if let label = self as? UILabel, let labelText = label.text, labelText.contains(searchText) {
            return label
        }

        if let stackView = self as? UIStackView {
            for arrangedSubview in stackView.arrangedSubviews where arrangedSubview.isHidden == false {
                if let label = arrangedSubview as? UILabel {
                    if let labelText = label.text, labelText.contains(searchText) {
                        return label
                    }
                }

                if let label = arrangedSubview.findLabel(containText: searchText) {
                    return label
                }
            }
        }

        for subview in subviews where subview.isHidden == false {
            if let label = subview as? UILabel {
                if let labelText = label.text, labelText.contains(searchText) {
                    return label
                }
            }

            if let label = subview.findLabel(containText: searchText) {
                return label
            }
        }
        return nil
    }

    @objc public func findButton(withTitle title: String) -> UIButton? {
        if let stackView = self as? UIStackView {
            for arrangedSubview in stackView.arrangedSubviews where arrangedSubview.isHidden == false {
                if let button = arrangedSubview as? UIButton {
                    if button.titleLabel?.text == title {
                        return button
                    }
                }

                if let button = arrangedSubview.findButton(withTitle: title) {
                    return button
                }
            }
        }

        for subview in subviews where subview.isHidden == false {
            if let button = subview as? UIButton {
                if button.titleLabel?.text == title {
                    return button
                }
            }

            if let button = subview.findButton(withTitle: title) {
                return button
            }
        }
        return nil
    }

    @objc public func findButton(withId text: String) -> UIButton? {
        if let button = self as? UIButton, button.accessibilityIdentifier == text {
            return button
        }

        for subview in subviews where subview.isHidden == false {
            if let button = self as? UIButton, button.accessibilityIdentifier == text {
                return button
            }

            if let button = subview.findButton(withId: text) {
                return button
            }
        }

        return nil
    }

    public func findImageView(withId text: String) -> UIImageView? {
        if let imageView = self as? UIImageView, imageView.accessibilityIdentifier == text {
            return imageView
        }

        if self is UIStackView {
            for subview in (self as! UIStackView).arrangedSubviews where subview.isHidden == false {
                if let imageView = subview as? UIImageView, imageView.accessibilityIdentifier == text {
                    return imageView
                }

                if let imageView = subview.findImageView(withId: text) {
                    return imageView
                }
            }

        } else {
            for subview in subviews where subview.isHidden == false {
                if let imageView = subview as? UIImageView, imageView.accessibilityIdentifier == text {
                    return imageView
                }

                if let imageView = subview.findImageView(withId: text) {
                    return imageView
                }
            }
        }

        return nil
    }

    public func findView(withId text: String) -> UIView? {
        if accessibilityIdentifier == text {
            return self
        }

        for subview in subviews where subview.isHidden == false {
            if subview.accessibilityIdentifier == text {
                return subview
            }

            if let view = subview.findView(withId: text) {
                return view
            }
        }

        return nil
    }

    public func findViews(withId text: String) -> [UIView] {
        var results = [UIView]()
        if accessibilityIdentifier == text {
            results.append(self)
        }

        let childViews = (self is UIStackView) ? (self as! UIStackView).arrangedSubviews : self.subviews
        for subview in childViews where subview.isHidden == false {
            let views = subview.findViews(withId: text)
            results.append(contentsOf: views)
        }

        return results
    }

    @objc public func findCellEditControl() -> UIControl? {
        for subview in subviews {
            let className = String(describing: type(of: subview))
            if className == "UITableViewCellEditControl" {
                return subview as? UIControl
            }

            if let control = subview.findCellEditControl() {
                return control
            }
        }

        return nil
    }

    @objc public func findSwitch(withId text: String) -> UISwitch? {
        if let stackView = self as? UIStackView {
            for arrangedSubview in stackView.arrangedSubviews where arrangedSubview.isHidden == false {
                if let uiSwitch = arrangedSubview as? UISwitch {
                    if uiSwitch.accessibilityIdentifier == text {
                        return uiSwitch
                    }
                }

                if let uiSwitch = arrangedSubview.findSwitch(withId: text) {
                    return uiSwitch
                }
            }
        }

        for subview in subviews where subview.isHidden == false {
            if let uiSwitch = subview as? UISwitch {
                if uiSwitch.accessibilityIdentifier == text {
                    return uiSwitch
                }
            }

            if let uiSwitch = subview.findSwitch(withId: text) {
                return uiSwitch
            }
        }
        return nil
    }

    func getTopConstraint() -> NSLayoutConstraint? {
        guard let superview = superview else {
            return nil
        }

        return superview.constraints.first { constraint in
            (constraint.firstItem as? UIView == self && constraint.firstAttribute == .top)
                || (constraint.secondItem as? UIView == self && constraint.secondAttribute == .top)
        }
    }

    func find<T>(_ accessibilityIdentifier: String, isHidden: Bool = false) -> T? where T: UIView {
        if let view = self as? T, view.match(accessibilityIdentifier: accessibilityIdentifier, isHidden: isHidden) {
            return view
        }

        for subview in subviews where subview.isHidden == isHidden {
            if let view = subview as? T, view.match(accessibilityIdentifier: accessibilityIdentifier, isHidden: isHidden) {
                return view
            }

            if let view = subview.find(accessibilityIdentifier, isHidden: isHidden) as? T {
                return view
            }
        }

        return nil
    }

    func match(accessibilityIdentifier: String, isHidden: Bool) -> Bool {
        self.accessibilityIdentifier == accessibilityIdentifier && self.isHidden == isHidden
    }

    @objc public func findRefreshControl() -> UIRefreshControl? {
        for subview in subviews {
            if let refreshControl = subview as? UIRefreshControl {
                return refreshControl
            }

            if let refreshControl = subview.findRefreshControl() {
                return refreshControl
            }
        }

        return nil
    }
}


extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
