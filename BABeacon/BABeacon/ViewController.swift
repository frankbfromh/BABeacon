//
//  ViewController.swift
//  BABeacon
//
//  Created by Frank Burgers on 24/11/16.
//  Copyright © 2016 Frank Burgers. All rights reserved.
//

import CoreBluetooth
import CoreLocation
import MessageUI
import UIKit

class ViewController: UIViewController, CBPeripheralManagerDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate
{
	fileprivate let startText = NSLocalizedString("Start", comment: "Start")
	fileprivate let stopText = NSLocalizedString("Stop", comment: "Stop")
	fileprivate let beABeacon = NSLocalizedString("Be A Beacon!", comment: "Be A Beacon!")
	fileprivate let beingABeacon = NSLocalizedString("Being A Beacon!", comment: "Being A Beacon!")
	fileprivate let secretID = "BABeacon"
	fileprivate let uuidKey = "uuid"
	fileprivate let majorKey = "major"
	fileprivate let minorKey = "minor"
	fileprivate let animationDuration = 0.2
	
	fileprivate let titleLabel = UILabel()
	fileprivate let uuidTextField = UITextField()
	fileprivate let minorTextField = UITextField()
	fileprivate let majorTextField = UITextField()
	fileprivate let buttonContainerView = UIView()
	fileprivate let startStopButton = UIButton()
	fileprivate let newUUIDButton = UIButton()
	fileprivate let emailBeaconConfigButton = UIButton()

	fileprivate var uuid = UUID().uuidString
	fileprivate var major = "0"
	fileprivate var minor = "0"
	fileprivate var keyboardIsShown = false
	fileprivate var isBeaconActive = false
	fileprivate var localBeacon: CLBeaconRegion?
	fileprivate var beaconPeripheralData: NSDictionary?
	fileprivate var peripheralManager: CBPeripheralManager?
	
	// MARK: - View lifecycle -
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		let cornerRadius: CGFloat = 5.0
		let textFieldInsetX: CGFloat = 10.0
		let textFieldFontSize: CGFloat = 12.0
		let buttonFontSize: CGFloat = 14.0
		
		view.backgroundColor = UIColor(hexString: "#9999AA")
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.text = beABeacon
		titleLabel.textAlignment = .center
		titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
		view.addSubview(titleLabel)
		
		if let storedUUID = UserDefaults.standard.string(forKey: uuidKey) {
			uuid = storedUUID
		}
		else {

			UserDefaults.standard.set(uuid, forKey: uuidKey)
			UserDefaults.standard.synchronize()
		}
		
		if let storedMajor = UserDefaults.standard.string(forKey: majorKey) {
			major = storedMajor
		}
		else {

			UserDefaults.standard.set(major, forKey: majorKey)
			UserDefaults.standard.synchronize()
		}

		if let storedMinor = UserDefaults.standard.string(forKey: minorKey) {
			minor = storedMinor
		}
		else {

			UserDefaults.standard.set(minor, forKey: minorKey)
			UserDefaults.standard.synchronize()
		}

		uuidTextField.translatesAutoresizingMaskIntoConstraints = false
		uuidTextField.backgroundColor = UIColor.white
		uuidTextField.layer.cornerRadius = cornerRadius
		uuidTextField.layer.sublayerTransform = CATransform3DMakeTranslation(textFieldInsetX, 0.0, 0.0)
		uuidTextField.placeholder = NSLocalizedString("UUID", comment: "UUID")
		uuidTextField.text = uuid
		uuidTextField.font = UIFont.systemFont(ofSize: textFieldFontSize)
		uuidTextField.keyboardType = .default
		uuidTextField.autocorrectionType = .no
		uuidTextField.autocapitalizationType = .none
		uuidTextField.returnKeyType = .next
		uuidTextField.delegate = self
		uuidTextField.addTarget(majorTextField, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
		view.addSubview(uuidTextField)
		
		majorTextField.translatesAutoresizingMaskIntoConstraints = false
		majorTextField.backgroundColor = UIColor.white
		majorTextField.layer.cornerRadius = cornerRadius
		majorTextField.layer.sublayerTransform = CATransform3DMakeTranslation(textFieldInsetX, 0.0, 0.0)
		majorTextField.placeholder = NSLocalizedString("Major", comment: "Major")
		majorTextField.text = major
		majorTextField.font = UIFont.systemFont(ofSize: textFieldFontSize)
		majorTextField.keyboardType = .numberPad
		majorTextField.autocorrectionType = .no
		majorTextField.autocapitalizationType = .none
		majorTextField.returnKeyType = .next
		majorTextField.delegate = self
		majorTextField.addTarget(minorTextField, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
		view.addSubview(majorTextField)
		
		minorTextField.translatesAutoresizingMaskIntoConstraints = false
		minorTextField.backgroundColor = UIColor.white
		minorTextField.layer.cornerRadius = cornerRadius
		minorTextField.layer.sublayerTransform = CATransform3DMakeTranslation(textFieldInsetX, 0.0, 0.0)
		minorTextField.placeholder = NSLocalizedString("Minor", comment: "Minor")
		minorTextField.text = minor
		minorTextField.font = UIFont.systemFont(ofSize: textFieldFontSize)
		minorTextField.keyboardType = .numberPad
		minorTextField.autocorrectionType = .no
		minorTextField.autocapitalizationType = .none
		minorTextField.returnKeyType = .go
		minorTextField.delegate = self
		minorTextField.addTarget(self, action: #selector(startStopButtonTapped), for: .editingDidEndOnExit)
		view.addSubview(minorTextField)
		
		buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
		buttonContainerView.backgroundColor = UIColor(hexString: "#BBBBCC")
		view.addSubview(buttonContainerView)
		
		startStopButton.translatesAutoresizingMaskIntoConstraints = false
		startStopButton.backgroundColor = UIColor.red
		startStopButton.showsTouchWhenHighlighted = true
		startStopButton.setTitle(NSLocalizedString(startText, comment: "StartStop"), for: .normal)
		startStopButton.titleLabel!.font = UIFont.systemFont(ofSize: buttonFontSize)
		startStopButton.layer.cornerRadius = cornerRadius
		startStopButton.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
		buttonContainerView.addSubview(startStopButton)
		
		newUUIDButton.translatesAutoresizingMaskIntoConstraints = false
		newUUIDButton.backgroundColor = UIColor.red
		newUUIDButton.showsTouchWhenHighlighted = true
		newUUIDButton.setTitle(NSLocalizedString("New UUID", comment: "New UUID"), for: .normal)
		newUUIDButton.titleLabel!.font = UIFont.systemFont(ofSize: buttonFontSize)
		newUUIDButton.layer.cornerRadius = cornerRadius
		newUUIDButton.addTarget(self, action: #selector(newUUIDButtonTapped), for: .touchUpInside)
		buttonContainerView.addSubview(newUUIDButton)
		
		emailBeaconConfigButton.translatesAutoresizingMaskIntoConstraints = false
		emailBeaconConfigButton.backgroundColor = UIColor.red
		emailBeaconConfigButton.showsTouchWhenHighlighted = true
		emailBeaconConfigButton.setTitle(NSLocalizedString("Email", comment: "Refresh"), for: .normal)
		emailBeaconConfigButton.titleLabel!.font = UIFont.systemFont(ofSize: buttonFontSize)
		emailBeaconConfigButton.layer.cornerRadius = cornerRadius
		emailBeaconConfigButton.addTarget(self, action: #selector(emailBeaconConfigButtonTapped), for: .touchUpInside)
		buttonContainerView.addSubview(emailBeaconConfigButton)

		let dismissKeyBoardTapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(_:)))
		view.addGestureRecognizer(dismissKeyBoardTapGesture)
		
		setupConstraints()
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool)
	{
		super.viewWillDisappear(animated)
		
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	// MARK: - Textfield delegate methods -
	
	func textFieldDidEndEditing(_ textField: UITextField)
	{
		guard let text = textField.text else {
			return
		}
		
		if textField == uuidTextField {
			
			if let _ = NSUUID(uuidString: text) {
				UserDefaults.standard.set(text, forKey: uuidKey)
			}
			else {

				showAlert(NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("Not a valid UUID", comment: "Not a valid UUID"), completion: {
					
					if self.uuidTextField.canBecomeFirstResponder == true {
						self.uuidTextField.becomeFirstResponder()
					}
				})
			}
		}
		else if textField == majorTextField {
			UserDefaults.standard.set(text, forKey: majorKey)
		}
		else if textField == minorTextField {
			UserDefaults.standard.set(text, forKey: minorKey)
		}
		
		UserDefaults.standard.synchronize()
	}
	
	// MARK: - Mailer delegate methods -
	
	internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
	{
		controller.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Helper methods -
	
	fileprivate func setupConstraints()
	{
		let buttonWidth = 84.0
		let buttonHeight = 32.0
		let buttonContainerHeight = 48.0
		let textHeight = 30.0
		let textMargin: CGFloat = 14.0

		let _ = titleLabel.layoutFullWidth(textMargin, rightMargin: textMargin)
		let _ = titleLabel.layoutHeight(textHeight)
		
		let _ = uuidTextField.layoutFullWidth(textMargin, rightMargin: textMargin)
		let _ = uuidTextField.layoutHeight(textHeight)

		let _ = majorTextField.layoutFullWidth(textMargin, rightMargin: textMargin)
		let _ = majorTextField.layoutHeight(textHeight)

		let _ = minorTextField.layoutFullWidth(textMargin, rightMargin: textMargin)
		let _ = minorTextField.layoutHeight(textHeight)
		
		let _ = buttonContainerView.layoutFullWidth()
		let _ = buttonContainerView.layoutHeight(buttonContainerHeight)

		let buttonOffset = Double((buttonContainerHeight - buttonHeight) / 2.0)

		let _ = startStopButton.layoutHeight(buttonHeight)
		let _ = startStopButton.layoutWidth(buttonWidth)
		let _ = startStopButton.layoutAnchorTop(buttonOffset)

		let _ = newUUIDButton.layoutHeight(buttonHeight)
		let _ = newUUIDButton.layoutWidth(buttonWidth)
		let _ = newUUIDButton.layoutAnchorTop(buttonOffset)

		let _ = emailBeaconConfigButton.layoutHeight(buttonHeight)
		let _ = emailBeaconConfigButton.layoutWidth(buttonWidth)
		let _ = emailBeaconConfigButton.layoutAnchorTop(buttonOffset)

		let smallMargin: CGFloat = 8.0
		let topMargin: CGFloat = 26.0
		let buttonsStartMargin = (UIScreen.main.bounds.width - 3.0 * (CGFloat(buttonWidth) + smallMargin)) / 2.0 + (smallMargin / 2.0)
		
		let _ = buttonContainerView.layoutSubviewsHorizontal([startStopButton, newUUIDButton, emailBeaconConfigButton], startMargin: buttonsStartMargin, endMargin: smallMargin, margin: smallMargin, capEnd: false, formatOptions: NSLayoutFormatOptions())
		let _ = view.layoutSubviewsVertical([titleLabel, uuidTextField, majorTextField, minorTextField, buttonContainerView], topMargin: topMargin, bottomMargin: textMargin, margin: textMargin, capEnd: false, formatOptions: NSLayoutFormatOptions())
	}
	
	fileprivate func showAlert(_ title: String, message: String, completion: (() -> Void)? = nil)
	{
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .cancel, handler: { Void in
			
			if let c = completion {
				c()
			}
			
			alertController.dismiss(animated: true, completion: nil)
		})
		
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	// MARK: - Keyboard methods -
	
	fileprivate func resignKeyboard()
	{
		if uuidTextField.isFirstResponder == true {
			uuidTextField.resignFirstResponder()
		}
		else if majorTextField.isFirstResponder == true {
			majorTextField.resignFirstResponder()
		}
		else if minorTextField.isFirstResponder == true {
			minorTextField.resignFirstResponder()
		}
	}
	
	@objc internal func keyboardWillShow(_ notification: Notification)
	{
		guard keyboardIsShown == false else {
			return
		}
		
		self.keyboardIsShown = true
	}
	
	@objc internal func keyboardWillHide(_ sender: UIGestureRecognizer)
	{
		guard keyboardIsShown == true else {
			return
		}
		
		resignKeyboard()
	}
	
	// MARK: - Button handler methods -
	
	@objc internal func startStopButtonTapped()
	{
		guard let uuid = self.uuidTextField.text, let _ = NSUUID(uuidString: uuid), uuid.isEmpty == false else {
			
			self.showAlert(NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("A valid UUID is mandatory.", comment: "UUIDIsMandatory")) {
				
				if self.uuidTextField.canBecomeFirstResponder == true {
					self.uuidTextField.becomeFirstResponder()
				}
			}
			
			return
		}
		
		resignKeyboard()
		
		isBeaconActive ? stopLocalBeacon() : initLocalBeacon()
		isBeaconActive = !isBeaconActive

		titleLabel.text = (isBeaconActive ? beingABeacon : beABeacon)

		uuidTextField.isUserInteractionEnabled = !isBeaconActive
		uuidTextField.backgroundColor = (isBeaconActive ? UIColor.lightText : UIColor.white)

		majorTextField.isUserInteractionEnabled = !isBeaconActive
		majorTextField.backgroundColor = (isBeaconActive ? UIColor.lightText : UIColor.white)
		
		minorTextField.isUserInteractionEnabled = !isBeaconActive
		minorTextField.backgroundColor = (isBeaconActive ? UIColor.lightText : UIColor.white)
		
		startStopButton.setTitle((isBeaconActive ? stopText : startText), for: .normal)

		newUUIDButton.isUserInteractionEnabled = !isBeaconActive
		newUUIDButton.backgroundColor = (isBeaconActive ? UIColor.darkGray : UIColor.red)
	}
	
	@objc internal func newUUIDButtonTapped()
	{
		uuid = UUID().uuidString
		uuidTextField.text = uuid
		UserDefaults.standard.set(uuid, forKey: uuidKey)
		UserDefaults.standard.synchronize()
	}
	
	@objc internal func emailBeaconConfigButtonTapped()
	{
		let composeVC = MFMailComposeViewController()
		
		var appNameAndVersion = "BABeacon"
		
		if let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
		   let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
		   let appBuildNr = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String {
			
			appNameAndVersion = "\(appName) \(appVersion)(\(appBuildNr))"
		}
		
		composeVC.mailComposeDelegate = self
		composeVC.setSubject("\(appNameAndVersion) config for device '\(UIDevice.current.name)'")
		composeVC.setMessageBody("Beacon configuration for device '\(UIDevice.current.name)':\n\nUUID: \(uuid)\nMajor: \(major)\nMinor: \(minor)", isHTML: false)
		
		present(composeVC, animated: true, completion: nil)
	}
	
	// MARK: - Beacon methods -
	
	fileprivate func initLocalBeacon()
	{
		guard let localBeaconUUID = uuidTextField.text else {
			return
		}

		let majorValue = (majorTextField.text?.isEmpty == false ? majorTextField.text! : "0")
		let minorValue = (minorTextField.text?.isEmpty == false ? minorTextField.text! : "0")

		if let localBeaconMajor: CLBeaconMajorValue = UInt16.init(majorValue), let localBeaconMinor: CLBeaconMinorValue = UInt16.init(minorValue) {
		
			if localBeacon != nil {
				stopLocalBeacon()
			}
			
			if let uuid = UUID(uuidString: localBeaconUUID) {

				localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: secretID)
				
				if let lb = localBeacon {

					beaconPeripheralData = lb.peripheralData(withMeasuredPower: nil)
					peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
				}
			}
		}
	}
	
	fileprivate func stopLocalBeacon()
	{
		if let perifMgr = peripheralManager {
			perifMgr.stopAdvertising()
		}

		peripheralManager = nil
		beaconPeripheralData = nil
		localBeacon = nil
	}
	
	internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
	{
		if let perifMgr = peripheralManager, let perifData = beaconPeripheralData {
			
			if peripheral.state == .poweredOn {
				perifMgr.startAdvertising((perifData as! [String : Any]))
			}
			else if peripheral.state == .poweredOff {
				perifMgr.stopAdvertising()
			}
		}
	}
}

