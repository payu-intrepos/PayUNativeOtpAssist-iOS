//
//  BaseViewController.swift
//  PayUNativeOtpAssistSwiftSample
//
//  Created by Amit Salaria on 25/06/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Class Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterKeyboardNotification()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}

// MARK: - Keyboard Handling -

extension BaseViewController: UIGestureRecognizerDelegate {
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func unRegisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        let info = notification.userInfo!
        let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let timeFrame = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let screenHeight = UIScreen.main.bounds.height
        
        let keyboardVisibleHeight = max(screenHeight - endFrame.minY, 0)
        
        for constraint in self.view.constraints {
            if constraint.firstAttribute == .bottom {
                // If first item is self's view then constant should be positive else it should be negative
                let multiplier = constraint.firstItem as? UIView == self.view ? 1 : -1
                constraint.constant =  CGFloat(multiplier) * keyboardVisibleHeight
            }
        }
        
        UIView.animate(withDuration: timeFrame) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - Alert Handling -

extension BaseViewController {
    
    func showAlert(title: String, message: Any?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: String(describing: message), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "DISMISS", style: .default, handler: { _ in
    //            self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
