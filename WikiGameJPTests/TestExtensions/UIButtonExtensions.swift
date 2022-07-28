import UIKit

extension UIControl {
    func tap() {
        sendActions(for: .touchUpInside)
    }
}

extension UISwitch {
    func toggle() {
        isOn = !isOn
        sendActions(for: .valueChanged)
    }
}
