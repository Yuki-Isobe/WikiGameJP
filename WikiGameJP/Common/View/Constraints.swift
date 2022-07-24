import UIKit

enum AnchorType: Int {
    case Top
    case Left
    case Right
    case Leading
    case Trailing
    case Bottom
    case CenterXAnchor
    case CenterYAnchor
    case Height
    case Width
}

extension UIView {
    private func disableAutoresizingMaskTranslationIfNeeded() {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    @discardableResult
    func constrainWidth(constant: CGFloat) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let constrain = self.widthAnchor.constraint(equalToConstant: constant)
        constrain.isActive = true

        return constrain
    }

    @discardableResult
    func constrainWidth(greaterThanOrEqualTo constant: CGFloat) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let constrain = self.widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        constrain.isActive = true

        return constrain
    }

    func constrainWidth(lessThanOrEqualTo constant: CGFloat) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        self.widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    }

    func constrainWidth(lessThanOrEqualTo anchor: NSLayoutDimension,
                        multiplier: CGFloat = 1.0) {
        self.disableAutoresizingMaskTranslationIfNeeded()
        self.widthAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: 0).isActive = true
    }

    @discardableResult
    func constrainWidth(
        equalTo otherAnchor: NSLayoutDimension,
        multiplier: CGFloat = 1.0,
        constant: CGFloat = 0.0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let constrain = self.widthAnchor.constraint(
            equalTo: otherAnchor,
            multiplier: multiplier,
            constant: constant
        )
        constrain.isActive = true

        return constrain
    }


    func constrainWidth(
        to otherAnchorType: AnchorType, of otherView: UIView, constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let constraint = self.widthAnchor.constraint(
            equalTo: anchor(type: otherAnchorType, of: otherView) as! NSLayoutAnchor
        )
        constraint.isActive = true
    }

    @discardableResult
    func constrainHeight(constant: CGFloat) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let constraint = self.heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true

        return constraint
    }

    func constrainHeight(lessThanOrEqualTo constant: CGFloat) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        self.heightAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    }

    func constrainHeight(greaterThanOrEqualTo constant: CGFloat) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        self.heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }

    func constrainHeight(to otherAnchorType: AnchorType, of otherView: UIView) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let constraint = self.heightAnchor.constraint(equalTo: anchor(type: otherAnchorType, of: otherView) as! NSLayoutAnchor)
        constraint.isActive = true
    }

    @discardableResult
    func constrainTop(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        let constraint = self.topAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func constrainTop(
        greaterThanOrEqualTo otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        let constraint = self.topAnchor.constraint(
            greaterThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true

        return constraint
    }

    func constrainTop(lessThanOrEqualTo otherAnchorType: AnchorType, of otherView: UIView, constant: CGFloat = 0) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        self.topAnchor.constraint(
            lessThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    @discardableResult
    func constrainLeft(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        let constraint = self.leftAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true
        return constraint
    }

    func constrainLeft(
        greaterThanOrEqualTo otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        self.leftAnchor.constraint(
            greaterThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    @discardableResult
    func constrainRight(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        let constraint = self.rightAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true

        return constraint
    }

    func constrainRight(
        lessThanOrEqualTo otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        self.rightAnchor.constraint(
            lessThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    func constrainRight(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        lessThanOrEqualTo constant: CGFloat
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        self.rightAnchor.constraint(
            lessThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    func constrainLeading(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        self.leadingAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    func constrainTrailing(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        self.trailingAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    @discardableResult
    func constrainBottom(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        let constraint = self.bottomAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true
        return constraint
    }

    func constrainBottom(
        lessThanOrEqualTo otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        self.bottomAnchor.constraint(
            lessThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    func constrainBottom(
        greaterThanOrEqualTo otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        self.bottomAnchor.constraint(
            greaterThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    func constrainBottom(
        to otherAnchorType: AnchorType,
        of layoutSupport: UILayoutSupport,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: layoutSupport)
        self.bottomAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    func constrainBottom(
        to otherAnchorType: AnchorType,
        of layoutGuide: UILayoutGuide,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: layoutGuide)
        self.bottomAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    @discardableResult
    func constrainXCenter(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        let constraint = self.centerXAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func constrainYCenter(
        to otherAnchorType: AnchorType,
        of otherView: UIView,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: otherView)
        let constraint = self.centerYAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func constrainTopNavigationBar(
        to otherAnchorType: AnchorType,
        of layoutSupport: UILayoutSupport,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: layoutSupport)
        let constraint = self.topAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true

        return constraint
    }

    func constrainTopNavigationBar(
        lessThanOrEqualTo otherAnchorType: AnchorType,
        of layoutSupport: UILayoutSupport,
        constant: CGFloat = 0) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: layoutSupport)
        self.topAnchor.constraint(
            lessThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    func constrainTopNavigationBar(
        greaterThanOrEqualTo otherAnchorType: AnchorType,
        of layoutSupport: UILayoutSupport,
        constant: CGFloat = 0) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: layoutSupport)
        self.topAnchor.constraint(
            greaterThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    @discardableResult
    func constrainTop(
        to otherAnchorType: AnchorType,
        of layoutGuide: UILayoutGuide,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: layoutGuide)
        let constraint = self.topAnchor.constraint(
            equalTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        )
        constraint.isActive = true

        return constraint
    }

    func constrainTop(
        lessThanOrEqualTo otherAnchorType: AnchorType,
        of layoutGuide: UILayoutGuide,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: layoutGuide)
        self.topAnchor.constraint(
            lessThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    func constrainTop(
        greaterThanOrEqualTo otherAnchorType: AnchorType,
        of layoutGuide: UILayoutGuide,
        constant: CGFloat = 0
    ) {
        self.disableAutoresizingMaskTranslationIfNeeded()

        let otherAnchor = anchor(type: otherAnchorType, of: layoutGuide)
        self.topAnchor.constraint(
            greaterThanOrEqualTo: otherAnchor as! NSLayoutAnchor,
            constant: constant
        ).isActive = true
    }

    private func anchor(type: AnchorType, of view: UIView) -> AnyObject {
        switch type {
        case .Top:
            return view.topAnchor
        case .Left:
            return view.leftAnchor
        case .Right:
            return view.rightAnchor
        case .Leading:
            return view.leadingAnchor
        case .Trailing:
            return view.trailingAnchor
        case .Bottom:
            return view.bottomAnchor
        case .CenterXAnchor:
            return view.centerXAnchor
        case .CenterYAnchor:
            return view.centerYAnchor
        case .Height:
            return view.heightAnchor
        case .Width:
            return view.widthAnchor
        }
    }

    private func anchor(type: AnchorType, of layoutSupport: UILayoutSupport) -> AnyObject {
        switch type {
        case .Top:
            return layoutSupport.topAnchor
        case .Bottom:
            return layoutSupport.bottomAnchor
        default:
            return layoutSupport.topAnchor
        }
    }

    private func anchor(type: AnchorType, of layoutGuide: UILayoutGuide) -> AnyObject {
        switch type {
        case .Top:
            return layoutGuide.topAnchor
        case .Bottom:
            return layoutGuide.bottomAnchor
        default:
            return layoutGuide.bottomAnchor
        }
    }

    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
}
