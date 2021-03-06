//
//  EditProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/22.
//

import UIKit
import Lottie

class EditProfileViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User
	
	private let nameTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: "Name")
		return label
	}()
	
	private let nameTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		textField.placeholder = "Name"
		return textField
	}()
	
	private let nameDividerView: UIView = {
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
		textField.placeholder = "School"
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
		textField.placeholder = "Major"
		return textField
	}()
	
	private let majorDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let introTextView: PlaceHolderTextView = {
		let textView = PlaceHolderTextView()
		
		if !textView.text.isEmpty {
			textView.placeholderLabel.isHidden = false
		} else {
			textView.placeholderLabel.isHidden = true
		}
		
		textView.font = UIFont.customFont(.manropeRegular, size: 12)
		textView.placeholderLabel.text = "Self Introduction"
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

		let nameVStack = makeVStack(label: nameTitleLabel, textField: nameTitleTextField, dividerView: nameDividerView)
		
		view.addSubview(nameVStack)
		nameVStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)

		let emailVStack = makeVStack(label: emailTitleLabel, textField: emailTitleTextField, dividerView: emailDividerView)
		
		view.addSubview(emailVStack)
		emailVStack.anchor(top: nameVStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)

		let schoolVStack = makeVStack(label: schoolTitleLabel, textField: schoolTitleTextField, dividerView: schoolDividerView)

		view.addSubview(schoolVStack)
		schoolVStack.anchor(top: emailVStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)

		let majorVStack = makeVStack(label: majorTitleLabel, textField: majorTitleTextField, dividerView: majorDividerView)
		
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
		setupAttributeNavBar(titleText: "Edit Profile")
		
		let leftItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftItemImage, style: .done, target: self,
														   action: #selector(popVC))
	}
	
	// MARK: - Actions
	
	@objc func handleDoneEditting() {
		guard let firstname = nameTitleTextField.text, !firstname.isEmpty,
			  let email = emailTitleTextField.text, !email.isEmpty,
			  let school = schoolTitleTextField.text,
			  let major = majorTitleTextField.text, let introduction = introTextView.text else {
			
			popUpMissingInputVC()
			return
		}
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		let name = "\(firstname)"
		let user = User(name: name, userID: user.userID, email: email, introContentText: introduction, school: school, schoolMajor: major,
						ratings: user.ratings, courseBooked: user.courseBooked, profileImageURL: user.profileImageURL,
						backgroundImageURL: user.backgroundImageURL, courses: user.courses, articles: user.articles, favoriteArticles: user.favoriteArticles, events: user.events, posts: user.posts, blockedUsers: user.blockedUsers, followers: user.followers, followings: user.followings, subject: user.subject, isTutor: user.isTutor)
		UserServie.shared.uploadUserData(user: user) { [weak self] in
			guard let self = self else { return }
			loadingLottie.stopAnimation()
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func makeVStack(label: UILabel, textField: UITextField, dividerView: UIView) -> UIStackView {
		let vStack = UIStackView(arrangedSubviews: [label, textField, dividerView])
		vStack.axis = .vertical
		vStack.spacing = 12
		return vStack
	}
	
	func configureUI() {
		nameTitleTextField.text = user.name
		emailTitleTextField.text = user.email
		schoolTitleTextField.text = user.school
		majorTitleTextField.text = user.schoolMajor
		introTextView.text = user.introContentText
	}
}
