//
//  CardDetailsViewController.swift
//  PayUNativeOtpAssistSwiftSample
//
//  Created by Amit Salaria on 25/06/21.
//

import UIKit
import PayUBizCoreKit
import PayUNativeOtpAssist
import PayUCustomBrowser

class CardDetailsViewController: BaseViewController {
    
    // MARK: - Variables -
    
    var key: String = ""
    var salt: String = ""
    var amount: String = ""
    var email: String = ""
    var userCredential: String = ""

    var cardNumber: String = ""
    var cardExpiryMonth: String = ""
    var cardExpiryYear: String = ""
    var cvv: String = ""
    var cardName: String = ""
    var cardToken: String = ""
    var shouldHandleFallback = false
    
    // MARK: - Private Variables -
    
    private var savedCards: [StoredCard] = []
    private var selectedIndex: Int?
    private var datePicker: UIDatePicker!
    private var toolBar: UIToolbar!
    private var cardExpiryDate = Date()
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardExpiryTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var savedSwitch: UISwitch!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var addNewCardView: UIView!
    @IBOutlet weak var savedCardTableView: UITableView!
    @IBOutlet weak var payButton: UIButton!

    // MARK: - Class Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDatePicker()
        updatePayButtonVisibility()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IBActions -
    
    @IBAction func saveCardSwitchAction(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        view.endEditing(true)
        prepareUserData()
        // Open SDK
        PayUOtpAssistSDKHelper.open(on: self, delegate: self, and: getUserDetailsDict())
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        view.endEditing(true)
        addNewCardView.isHidden = sender.selectedSegmentIndex == 1
        savedCardTableView.isHidden = sender.selectedSegmentIndex != 1
        selectedIndex = nil
        savedCardTableView.reloadData()
        fetchSavedCardsIfNeeded()
        prepareUserData()
        updatePayButtonVisibility()
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        prepareUserData()
        updatePayButtonVisibility()
    }

    // MARK: - Private Functions -
    
    private func setUpDatePicker() {
        // DatePicker
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.center = view.center
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
        }
        // ToolBar
        toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolBar.setItems([spaceButton, cancelButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.isHidden = false
        
        cardExpiryTextField.inputAccessoryView = toolBar
        cardExpiryTextField.inputView = datePicker
        
        self.datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    
    @objc func doneClick () {
        view.endEditing(true)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        cardExpiryDate = sender.date
        updateExpiryDateTextField()
    }
    
    private func updatePayButtonVisibility() {
        let isEnable = (!cardNumber.isEmpty && !cardExpiryYear.isEmpty && !cardExpiryMonth.isEmpty && !cvv.isEmpty && !cardName.isEmpty)
        payButton.isUserInteractionEnabled = isEnable
        payButton.backgroundColor = payButton.backgroundColor?.withAlphaComponent(isEnable ? 1 : 0.5)
    }
    
    private func updateExpiryDateTextField() {
        cardExpiryTextField.text = cardExpiryDate.stringFromDate(format: .mmyyyy, type: .local)
    }
    
    private func fetchSavedCardsIfNeeded() {
        if savedCards.isEmpty && segmentControl.selectedSegmentIndex == 1 {
            Loader.shared.show()
            SavedCardsAPI.fetchAll(paymentParam: getPaymentParamToFetchSavedCards()) { cards in
                DispatchQueue.main.async {
                    self.savedCards = cards
                    self.savedCardTableView.reloadData()
                    Loader.shared.hide()
                }
            }
            
        }
    }
    
    private func prepareUserData() {
        guard let selectedIndex = selectedIndex else {
            cardNumber = cardNumberTextField.text ?? ""
            cardExpiryMonth = cardExpiryDate.stringFromDate(format: .mm, type: .local)
            cardExpiryYear = cardExpiryDate.stringFromDate(format: .yyyy, type: .local)
            cvv = cvvTextField.text ?? ""
            cardName = cardNameTextField.text ?? ""
            cardToken = ""
            return
        }
        cardNumber = savedCards[selectedIndex].number
        cardExpiryMonth = savedCards[selectedIndex].month
        cardExpiryYear = savedCards[selectedIndex].year
        cardName = savedCards[selectedIndex].name
        cvv = savedCards[selectedIndex].cvv ?? ""
        cardToken = savedCards[selectedIndex].token ?? ""
    }
    
    private func getUserDetailsDict() -> [String: Any] {
        var dict = [String: Any]()
        dict[SampleAppConstants.amount] = amount
        dict[SampleAppConstants.key] = key
        dict[SampleAppConstants.salt] = salt
        dict[SampleAppConstants.email] = email
        dict[SampleAppConstants.cardNumber] = cardNumber
        dict[SampleAppConstants.cardExpiryMonth] = Int(cardExpiryMonth)
        dict[SampleAppConstants.cardExpiryYear] = Int(cardExpiryYear)
        dict[SampleAppConstants.cardName] = cardName
        dict[SampleAppConstants.cvv] = cvv
        dict[SampleAppConstants.cardToken] = cardToken
        dict[SampleAppConstants.userCredential] = userCredential
        dict[SampleAppConstants.saveCard] = savedSwitch.isOn
        return dict
    }
    
    private func getPaymentParamToFetchSavedCards() -> PayUModelPaymentParams {
        let paymentParam = PayUModelPaymentParams()
        paymentParam.key = key
        paymentParam.hashes.paymentRelatedDetailsHash = getPaymentRelatedDetailsHash()
        paymentParam.userCredentials = userCredential
        return paymentParam
    }
    
    private func getPaymentParamToSaveNewCard(_ dict: [String: Any]) -> PayUModelPaymentParams {
        let paymentParam = PayUModelPaymentParams()
        paymentParam.key = key
        paymentParam.userCredentials = userCredential
        paymentParam.cardName = cardName
        paymentParam.cardMode = "DC"
        paymentParam.cardType = dict[SampleAppConstants.bankcode] as? String ?? ""
        paymentParam.nameOnCard = cardName
        paymentParam.cardNo = cardNumber
        paymentParam.expiryMonth = cardExpiryMonth
        paymentParam.expiryYear = cardExpiryYear
        paymentParam.duplicateCheck = "1"
        let hashString = "\(key)|save_user_card|\(userCredential)|\(salt)"
        paymentParam.hashes.saveUserCardHash = PayUDontUseThisClass().getHash(hashString)
        
        return paymentParam
    }

    private func saveUserCardIfNeeded(_ response: String?) {
//        if !savedSwitch.isOn {
//            return
//        }
//        guard let data = response?.data(using: .utf8) else { return }
//        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as?  [String: Any] else { return }
//        SavedCardsAPI.saveCard(paymentParam: getPaymentParamToSaveNewCard(json))
    }
    
    private func getPaymentRelatedDetailsHash() -> String {
        let hashString = (key + "|" + COMMAND_PAYMENT_RELATED_DETAILS_FOR_MOBILE_SDK + "|" + PayUUtils.passEmptyStringFornilValues(userCredential) + "|" + salt)
        return PayUDontUseThisClass().getHash(hashString)
    }
    
    private func openCB() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            do {
                let webVC = try PUCBWebVC(
                    postParam: PUCBConfiguration.getSingletonInstance()?.paymentPostParam ?? "=",
                    url: URL(string: PUCBConfiguration.getSingletonInstance()?.paymentURL ?? "https://www.google.com"),
                    merchantKey: self.key
                )
                webVC.cbWebVCDelegate = self
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.present(webVC, animated: true)
            } catch let error {
                self.onError(errorCode: "0", errorMessage: error.localizedDescription)
            }
        })
    }
    
}

// MARK: - UITableViewDataSource -

extension CardDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        (cell.contentView.viewWithTag(10) as? UILabel)?.text = savedCards[indexPath.row].number
        (cell.contentView.viewWithTag(11) as? UITextField)?.text = savedCards[indexPath.row].cvv
        (cell.contentView.viewWithTag(11) as? UITextField)?.isHidden = indexPath.row != selectedIndex
        (cell.contentView.viewWithTag(11) as? UITextField)?.addTarget(self, action: #selector(cvvDidChange(_:)), for: .editingChanged)
        cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        return cell
    }
    
    @objc func cvvDidChange(_ sender: UITextField) {
        guard let selectedIndex = selectedIndex else { return }
        savedCards[selectedIndex].cvv = sender.text
        prepareUserData()
        updatePayButtonVisibility()
    }
}

// MARK: - UITableViewDelegate -

extension CardDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        savedCards[indexPath.row].cvv = nil
        selectedIndex = indexPath.row
        savedCardTableView.reloadData()
        prepareUserData()
        updatePayButtonVisibility()
    }
    
}

// MARK: - PayUOtpAssistDelegate -

extension CardDetailsViewController: PayUOtpAssistDelegate {
        
    func onPaymentSuccess(merchantResponse: String?, payUResponse: String?) {
        saveUserCardIfNeeded(merchantResponse)
        showAlert(title: "onPaymentSuccess", message: (merchantResponse ?? "") + (payUResponse ?? ""))
    }
    
    func onPaymentFailure(merchantResponse: String?, payUResponse: String?) {
        showAlert(title: "onPaymentFailure", message: (merchantResponse ?? "") + (payUResponse ?? ""))
    }
    
    func onPaymentCancel(isTxnInitiated: Bool) {
        showAlert(title: "onPaymentCancel", message: "isTxnInitiated: \(isTxnInitiated)")
    }
    
    func onError(errorCode: String?, errorMessage: String?) {
        showAlert(title: "onError", message: errorMessage)
    }
    
    func shouldHandleFallback(payUAcsRequest: PayUAcsRequest) -> Bool {
        
        if shouldHandleFallback {   // Return 'true', when merchant doesn't want to handle fallback scenarios
            return true
        }
        
        // Set the merchantKey and transactionId
        PUCBConfiguration.getSingletonInstance()?.merchantKey = key
        PUCBConfiguration.getSingletonInstance()?.transactionId = payUAcsRequest.transactionId ?? ""

        if let issuerUrl = payUAcsRequest.issuerUrl, let issuerPostData = payUAcsRequest.issuerPostData, !issuerUrl.isEmpty {
            // Set the issuerUrl and issuerPostData to open in WebView
            PUCBConfiguration.getSingletonInstance()?.paymentPostParam = issuerPostData
            PUCBConfiguration.getSingletonInstance()?.paymentURL = issuerUrl
        }
        else
        if let acsTemplate = payUAcsRequest.acsTemplate {
            // Set the acsTemplate to open in WebView
            PUCBConfiguration.getSingletonInstance()?.htmlData = acsTemplate
        }

        // Open CB
        openCB()

        return false
    }
    
}

// MARK: - PUCBWebVCDelegate -

extension CardDetailsViewController: PUCBWebVCDelegate {
    
    func payUSuccessResponse(_ response: Any!) {
        showAlert(title: "payUSuccessResponse", message: response)
    }
    
    func payUFailureResponse(_ response: Any!) {
        showAlert(title: "payUFailureResponse", message: response)
    }
    
    func payUConnectionError(_ notification: [AnyHashable : Any]!) {
        showAlert(title: "payUConnectionError", message: notification)
    }
    
    func payUTransactionCancel() {
        showAlert(title: "payUTransactionCancel", message: "")
    }
    
    func payUSuccessResponse(_ payUResponse: Any!, surlResponse: Any!) {
        showAlert(title: "payUSuccessResponse", message: payUResponse)
    }
    
    func payUFailureResponse(_ payUResponse: Any!, furlResponse: Any!) {
        showAlert(title: "payUFailureResponse", message: payUResponse)
    }
    
}
