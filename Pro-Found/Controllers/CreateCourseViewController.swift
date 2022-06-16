//
//  CreateCourseViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import UIKit

class CreateCourseViewController: UIViewController {
	
	// MARK: - Properties
	
	var user: User
	
	private let courseTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark, text: "Course Title")
		return label
	}()
	
	private let courseTitleTextField: UITextField = {
		let textField = UITextField()
		return textField
	}()
	
	private let courseTitleDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		return dividerView
	}()
	
	private let addressTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark, text: "Location")
		return label
	}()
	
	private let addressTitleTextField: UITextField = {
		let textField = UITextField()
		return textField
	}()
	
	private let addressDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		return dividerView
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
		textField.placeholder = "$"
		textField.font = UIFont.customFont(.interBold, size: 28)
		return textField
	}()
	
	private lazy var createButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .white,
														borderColor: .clear, buttonText: "Create Course")
		button.widthAnchor.constraint(equalToConstant: 128).isActive = true
		button.addTarget(self, action: #selector(createCourse), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	init(user: User) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
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
		view.addSubview(courseTitleLabel)
		courseTitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(courseTitleTextField)
		courseTitleTextField.anchor(top: courseTitleLabel.bottomAnchor, left: view.leftAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(courseTitleDividerView)
		courseTitleDividerView.anchor(top: courseTitleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
									  paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		courseTitleDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		
		view.addSubview(addressTitleLabel)
		addressTitleLabel.anchor(top: courseTitleDividerView.bottomAnchor, left: view.leftAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(addressTitleTextField)
		addressTitleTextField.anchor(top: addressTitleLabel.bottomAnchor, left: view.leftAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(addressDividerView)
		addressDividerView.anchor(top: addressTitleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
								  paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		addressDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true

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
		subjectSelectionHStack.anchor(top: addressDividerView.bottomAnchor, left: view.leftAnchor,
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
	
	@objc func createCourse() {
		
		let buttons = [languageButton, techButton, artButton, musicButton, sportButton]
		let selectedButton = buttons.filter({ $0.isSelected })
		guard let courseTitleText = courseTitleTextField.text, !courseTitleText.isEmpty,
			  let addressText = addressTitleTextField.text, !addressText.isEmpty,
			  let briefText = briefTextView.text, !briefText.isEmpty,
			  let introText = introductionTextView.text, !introText.isEmpty,
			  let feetext = feeTextField.text, !feetext.isEmpty,
			  let feetextDouble = Double(feetext) else { return }
		guard selectedButton.count > 0 else { return }
		guard let selectedSubject = selectedButton.first?.titleLabel?.text else { return }
		let course = Course(userID: user.userID, tutorName: user.name, courseTitle: courseTitleText,
							subject: selectedSubject, location: addressText, fee: feetextDouble, briefIntro: briefText,
							detailIntro: introText)
		
		CourseServie.shared.uploadNewCourse(course: course, user: user)
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
