//
//  MerchantViewController.swift
//  PayUNativeOtpAssistSwiftSample
//
//  Created by Amit Salaria on 25/06/21.
//

import UIKit
class MerchantViewController: BaseViewController {
    // MARK: - Variables -
    let keySalt = [["3TnMpV", "<Please_add_test_salt_here>"],
                   ["gtKFFx", "<Please_add_test_salt_here>"]]
    
    let indexKeySalt = 4
    var amount: String = "1"
    var email: String = "amit@salaria.com"
    var userCredential: String = "umang:arya123"

    // MARK: - IBOutlets -
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var saltTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userCredentialTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shouldHandleFallbackSwitch: UISwitch!

    // MARK: - Class Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpValuesInTextFields()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let vc = segue.destination as? CardDetailsViewController else { return }
        vc.key = keyTextField.text ?? ""
        vc.salt = saltTextField.text ?? ""
        vc.amount = amountTextField.text ?? ""
        vc.email = emailTextField.text ?? ""
        vc.userCredential = userCredentialTextField.text ?? ""
        vc.shouldHandleFallback = shouldHandleFallbackSwitch.isOn
    }
    
    // MARK: - IBActions -
    
    @IBAction func nextButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        performSegue(withIdentifier: kCardDetailsViewController, sender: nil)
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        updateNextButtonVisibility()
    }
    
}

// MARK: - Private Methods -

extension MerchantViewController {
    
    private func setUpValuesInTextFields() {
        keyTextField.text = keySalt[indexKeySalt][0]
        saltTextField.text = keySalt[indexKeySalt][1]
        amountTextField.text = amount
        emailTextField.text = email
        userCredentialTextField.text = userCredential
    }
    
    private func updateNextButtonVisibility() {
        let isEnable = ((keyTextField.text?.isEmpty == false) && (saltTextField.text?.isEmpty == false) && (amountTextField.text?.isEmpty == false) && (emailTextField.text?.isEmpty == false))
        nextButton.isUserInteractionEnabled = isEnable
        nextButton.backgroundColor = nextButton.backgroundColor?.withAlphaComponent(isEnable ? 1 : 0.5)
    }

}
