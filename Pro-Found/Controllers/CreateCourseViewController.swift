//
//  CreateCourseViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import UIKit

class CreateCourseViewController: UIViewController {
	
	// MARK: - Properties
	
	private let courseTitleInputView: UIView = {
		let view = CustomUIElements().inputContainerView(labelText: "Course Title")
		return view
	}()
	
	private let addressInputView: UIView = {
		let view = CustomUIElements().inputContainerView(labelText: "Address")
		return view
	}()
	
	private lazy var languageButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.language)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private lazy var techButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.technology)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private lazy var artButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.art)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private lazy var musicButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.music)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private lazy var sportButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.sport)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private let briefIntroLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: UIColor.dark, text: "Course Summary")
		return label
	}()
	
	private let briefTextView: UITextView = {
		let textView = UITextView()
		textView.layer.borderColor = UIColor.dark20.cgColor
		textView.layer.borderWidth = 1
		textView.layer.cornerRadius = 8
		return textView
	}()
	
	private let introductionLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: UIColor.dark, text: "Course Introduction")
		return label
	}()
	
	private let introductionTextView: UITextView = {
		let textView = UITextView()
		textView.layer.borderColor = UIColor.dark20.cgColor
		textView.layer.borderWidth = 1
		textView.layer.cornerRadius = 8
		return textView
	}()
	
	private lazy var currencyButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .clear, buttonTextColor: .orange,
														borderColor: .orange, buttonText: "US", borderWidth: 1)
		button.widthAnchor.constraint(equalToConstant: 50).isActive = true
		return button
	}()
	
	private let feeTextField: UITextField = {
		let textField = UITextField()
		textField.keyboardType = .numberPad
		textField.text = "$"
		textField.font = UIFont.customFont(.interBold, size: 28)
		return textField
	}()
	
	private lazy var createButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .white,
														borderColor: .clear, buttonText: "Create Course")
		button.widthAnchor.constraint(equalToConstant: 128).isActive = true
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		title = "Create Course"
		setupNavBar()
		setupUI()
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		endSetupNavBar()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(courseTitleInputView)
		courseTitleInputView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(addressInputView)
		addressInputView.anchor(top: courseTitleInputView.bottomAnchor, left: view.leftAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		let subjectSelectionHStack = UIStackView(arrangedSubviews: [
			languageButton,
			techButton,
			artButton,
			musicButton,
			sportButton
		])
		subjectSelectionHStack.axis = .horizontal
		subjectSelectionHStack.distribution = .fillEqually
		subjectSelectionHStack.spacing = 2
		
		view.addSubview(subjectSelectionHStack)
		subjectSelectionHStack.anchor(top: addressInputView.bottomAnchor, left: view.leftAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
		
		view.addSubview(briefIntroLabel)
		briefIntroLabel.anchor(top: subjectSelectionHStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(briefTextView)
		briefTextView.anchor(top: briefIntroLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 100)
		
		view.addSubview(introductionLabel)
		introductionLabel.anchor(top: briefTextView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(introductionTextView)
		introductionTextView.anchor(top: introductionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(currencyButton)
		currencyButton.anchor(top: introductionTextView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
							  paddingTop: 24, paddingLeft: 16, paddingBottom: 12)
		
		view.addSubview(createButton)
		createButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 12, paddingRight: 16)
		
		view.addSubview(feeTextField)
		feeTextField.centerY(inView: currencyButton, leftAnchor: currencyButton.rightAnchor, paddingLeft: 8)
		feeTextField.heightAnchor.constraint(equalTo: currencyButton.heightAnchor).isActive = true
		feeTextField.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -8).isActive = true
		
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = false
		let titleAttribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.customFont(.interBold, size: 16)
		]
		let appearance = UINavigationBarAppearance()
		appearance.titleTextAttributes = titleAttribute
		appearance.configureWithDefaultBackground()
		navigationController?.navigationBar.standardAppearance = appearance
		let image = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(popVC))
		
		tabBarController?.tabBar.isHidden = true
	}
	
	func endSetupNavBar() {
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - Actions
	
	@objc func selectedSubject(_ sender: UIButton) {
		let buttons = [languageButton, techButton, artButton, musicButton, sportButton]
		
		switch sender {
		case languageButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: languageButton)
		case techButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: techButton)
		case artButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: artButton)
		case musicButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: musicButton)
		case sportButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: sportButton)
		default:
			break
		}
	}
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func toggleSelectedSubjectButton(buttons: [UIButton], selectedButton: UIButton) {
		for i in 0...buttons.count - 1 {
			buttons[i].isSelected = false
			buttons[i].backgroundColor = .dark10
		}
		selectedButton.isSelected = true
		selectedButton.backgroundColor = .orange
	}
}
