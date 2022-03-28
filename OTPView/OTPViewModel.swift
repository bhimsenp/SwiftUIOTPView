import Combine
import Foundation
import UIKit

class OTPViewModel: ObservableObject {
    @Published var items: [OTPItem] = []
    @Published var focusedItem: Int?
    @Published var enteredOTP = "" { didSet { changed() } }
    var onOTPChanged: (String) -> Void
    private let maxDigits: Int
    let keyboardType: UIKeyboardType
    let autoFocus: Bool

    init(digits: Int, keyboardType: UIKeyboardType = .numberPad, autoFocus: Bool = false, onOTPChanged: @escaping (String) -> Void) {
        self.maxDigits = digits
        self.items = (0..<maxDigits).map({ _ in
            OTPItem(digit: "")
        })
        self.autoFocus = autoFocus
        self.keyboardType = keyboardType
        self.onOTPChanged = onOTPChanged
    }

    private func changed() {
        if enteredOTP.count > maxDigits {
            enteredOTP.remove(at: enteredOTP.index(before: enteredOTP.endIndex))
        }
        focusedItem = enteredOTP.count == maxDigits ? nil : enteredOTP.count
        for index in items.indices {
            items[index].digit = enteredOTP.count > index ? "\(enteredOTP[index])" : ""
        }
        if enteredOTP.count == maxDigits {
            onOTPChanged(enteredOTP)
        }
    }

    func focusChanged(_ isFocused: Bool) {
        focusedItem = isFocused ? (enteredOTP.count == maxDigits ? maxDigits - 1 : enteredOTP.count) : nil
    }

    func onAppear() {
        if autoFocus {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
                self?.focusedItem = 0
            }
        }
    }
}

struct OTPItem: Identifiable, Hashable {
    let id = UUID()
    var digit: String
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
