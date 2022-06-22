//
//  EditProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/22.
//

import UIKit

class EditProfileViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User
	
	private let firstnameTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: "First Name")
		return label
	}()
	
	private let firstnameTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		textField.placeholder = "First Name"
		return textField
	}()
	
	private let firstnameDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let lastnameTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: "Last Name")
		return label
	}()
	
	private let lastnameTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		textField.placeholder = "Last Name"
		return textField
	}()
	
	private let lastnameDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let emailTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: "Email")
		return label
	}()
	
	private let emailTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		textField.placeholder = "Email"
		return textField
	}()
	
	private let emailDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let schoolTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: "School")
		return label
	}()
	
	private let schoolTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		textField.placeholder = "Email"
		return textField
	}()
	
	private let schoolDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let majorTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: "Major")
		return label
	}()
	
	private let majorTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		textField.placeholder = "Email"
		return textField
	}()
	
	private let majorDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let introTextView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.customFont(.manropeRegular, size: 12)
		textView.layer.borderColor = UIColor.orange.cgColor
		textView.layer.borderWidth = 1
		textView.layer.cornerRadius = 10
		return textView
	}()
	
	private lazy var doneButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .light60, borderColor: .clear, buttonText: "Done")
		button.addTarget(self, action: #selector(handleDoneEditting), for: .touchUpInside)
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
		view.backgroundColor = .orange10
		
		setupNavBar()
		setupUI()
		configureUI()
    }
	
	// MARK: - UI
	
	private func setupUI() {
		
		let firstNameVStack = UIStackView(arrangedSubviews: [firstnameTitleLabel, firstnameTitleTextField, firstnameDividerView])
		firstNameVStack.axis = .vertical
		firstNameVStack.spacing = 12
		
		view.addSubview(firstNameVStack)
		firstNameVStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		let lastNameVStack = UIStackView(arrangedSubviews: [lastnameTitleLabel, lastnameTitleTextField, lastnameDividerView])
		lastNameVStack.axis = .vertical
		lastNameVStack.spacing = 12
		
		view.addSubview(lastNameVStack)
		lastNameVStack.anchor(top: firstNameVStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		let emailVStack = UIStackView(arrangedSubviews: [emailTitleLabel, emailTitleTextField, emailDividerView])
		emailVStack.axis = .vertical
		emailVStack.spacing = 12
		
		view.addSubview(emailVStack)
		emailVStack.anchor(top: lastNameVStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		let schoolVStack = UIStackView(arrangedSubviews: [schoolTitleLabel, schoolTitleTextField, schoolDividerView])
		schoolVStack.axis = .vertical
		schoolVStack.spacing = 12
		
		view.addSubview(schoolVStack)
		schoolVStack.anchor(top: emailVStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		let majorVStack = UIStackView(arrangedSubviews: [majorTitleLabel, majorTitleTextField, majorDividerView])
		majorVStack.axis = .vertical
		majorVStack.spacing = 12
		
		view.addSubview(majorVStack)
		majorVStack.anchor(top: schoolVStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(introTextView)
		introTextView.anchor(top: majorVStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							 paddingTop: 16 , paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(doneButton)
		doneButton.anchor(top: introTextView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
						  right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		
	}
	
	private func setupNavBar() {
		title = "Edit Profile"
		let titleAttribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.customFont(.interBold, size: 16)
		]
		let appearance = UINavigationBarAppearance()
		appearance.titleTextAttributes = titleAttribute
		appearance.configureWithDefaultBackground()
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.isHidden = false
		let leftItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftItemImage, style: .done, target: self,
														   action: #selector(popVC))
		tabBarController?.tabBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func handleDoneEditting() {
		guard let firstname = firstnameTitleTextField.text, let lastname = lastnameTitleTextField.text, let email = emailTitleTextField.text,
			  let school = schoolTitleTextField.text, let major = majorTitleTextField.text, let introduction = introTextView.text else { return }
		let name = "\(lastname) \(firstname)"
		let user = User(name: name, userID: user.userID, email: email, introContentText: introduction, school: school, schoolMajor: major,
						ratings: user.ratings, courseBooked: user.courseBooked, profileImageURL: user.profileImageURL,
						backgroundImageURL: user.backgroundImageURL, courses: user.courses, articles: user.articles,
						events: user.events, posts: user.posts, blockedUsers: user.blockedUsers, followers: user.followers,
						followings: user.followings, subject: user.subject, isTutor: user.isTutor)
		UserServie.shared.uploadUserData(user: user) { [weak self] in
			guard let self = self else { return }
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		let name = user.name.split(separator: " ")
		firstnameTitleTextField.text = String(name[1])
		lastnameTitleTextField.text = String(name[0])
		emailTitleTextField.text = user.email
		schoolTitleTextField.text = user.school
		majorTitleTextField.text = user.schoolMajor
		introTextView.text = user.introContentText
	}
}
