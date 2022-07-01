//
//  CreateEventViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/19.
//

import UIKit
import PhotosUI
import Lottie

class CreateEventViewController: UIViewController {
	
	// MARK: - Properties
	
	var user: User
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		let titleLabel = UILabel()
		titleLabel.text = "Create Event"
		titleLabel.font = UIFont.customFont(.interBold, size: 16)
		titleLabel.textColor = .dark
		view.addSubview(titleLabel)
		titleLabel.center(inView: view)
		
		return view
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.close), for: .normal)
		button.setDimensions(width: 24, height: 24)
		button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		return button
	}()
	
	private let eventImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .orange10
		imageView.layer.cornerRadius = 12
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.setDimensions(width: 132, height: 200)
		return imageView
	}()
	
	private let eventTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark, text: "Event Name")
		return label
	}()
	
	private let eventTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 14)
		return textField
	}()
	
	private let eventTitleDividerView: UIView = {
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
		textField.font = UIFont.customFont(.manropeRegular, size: 14)
		return textField
	}()
	
	private let addressDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		return dividerView
	}()
	
	private lazy var datePicker: UIDatePicker = {
		let picker = UIDatePicker()
		picker.datePickerMode = .dateAndTime
		picker.preferredDatePickerStyle = .wheels
		picker.tintColor = .orange
		picker.minuteInterval = 30
		let currentDate = Date()
		let afterThreeMonthsdate = Calendar.current.date(byAdding: .month, value: 3, to: currentDate)
		picker.maximumDate = afterThreeMonthsdate
		picker.minimumDate = currentDate
		return picker
	}()
	
	private let briefIntroLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: UIColor.dark, text: "Event Introduction")
		return label
	}()
	
	private let briefTextView: UITextView = {
		let textView = UITextView()
		textView.layer.borderColor = UIColor.dark20.cgColor
		textView.layer.borderWidth = 1
		textView.layer.cornerRadius = 8
		textView.font = UIFont.customFont(.manropeRegular, size: 14)
		return textView
	}()
	
	private lazy var pickImageButton: UIButton = {
		let button = UIButton()
		button.setDimensions(width: 24, height: 24)
		button.setImage(UIImage.asset(.photo), for: .normal)
		button.addTarget(self, action: #selector(handlePickingImage), for: .touchUpInside)
		return button
	}()
	
	private lazy var createEventButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .white,
														borderColor: .clear, buttonText: "Create Event")
		button.widthAnchor.constraint(equalToConstant: 128).isActive = true
		button.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
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
		setupUI()
		
	}
	
	// MARK: - UI
	
	private func setupUI() {
		
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(cancelButton)
		cancelButton.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 18)
		
		view.addSubview(eventImageView)
		eventImageView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		view.addSubview(eventTitleLabel)
		eventTitleLabel.anchor(top: topBarView.bottomAnchor, left: eventImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(eventTitleTextField)
		eventTitleTextField.anchor(top: eventTitleLabel.bottomAnchor, left: eventImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)

		view.addSubview(eventTitleDividerView)
		eventTitleDividerView.anchor(top: eventTitleTextField.bottomAnchor, left: eventImageView.rightAnchor, right: view.rightAnchor,
									  paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)

		view.addSubview(addressTitleLabel)
		addressTitleLabel.anchor(top: eventTitleDividerView.bottomAnchor, left: eventImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)

		view.addSubview(addressTitleTextField)
		addressTitleTextField.anchor(top: addressTitleLabel.bottomAnchor, left: eventImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)

		view.addSubview(addressDividerView)
		addressDividerView.anchor(top: addressTitleTextField.bottomAnchor, left: eventImageView.rightAnchor, right: view.rightAnchor,
									  paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		view.addSubview(datePicker)
		datePicker.anchor(top: eventImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16,
						  paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(briefIntroLabel)
		briefIntroLabel.anchor(top: datePicker.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		view.addSubview(briefTextView)
		briefTextView.anchor(top: briefIntroLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16,
							 paddingLeft: 16, paddingRight: 16, height: 100)
		
		view.addSubview(createEventButton)
		createEventButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 12, paddingRight: 16)
		
		view.addSubview(pickImageButton)
		pickImageButton.centerY(inView: createEventButton, leftAnchor: view.leftAnchor, paddingLeft: 16)
	}
	
	// MARK: - Actions
	
	@objc func handlePickingImage() {
		let actionSheet = UIAlertController(title: "Select Photo", message: "Where do you want to select a photo?",
											preferredStyle: .actionSheet)
		
		let photoAction = UIAlertAction(title: "Photos", style: .default) { (action) in
			var configuration = PHPickerConfiguration()
			configuration.selectionLimit = 1
			let picker = PHPickerViewController(configuration: configuration)
			picker.delegate = self
			
			if let sheet = picker.presentationController as? UISheetPresentationController {
				sheet.detents = [.medium(), .large()]
				sheet.preferredCornerRadius = 25
			}
			self.present(picker, animated: true, completion: nil)
		}
		actionSheet.addAction(photoAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		actionSheet.addAction(cancelAction)
		
		self.present(actionSheet, animated: true, completion: nil)
	}
	
	@objc func createEvent() {
		guard let eventTitle = eventTitleTextField.text, !eventTitle.isEmpty,
			  let addreddText = addressTitleTextField.text, !addreddText.isEmpty,
			  let introText = briefTextView.text, !introText.isEmpty,
			  let eventImage = eventImageView.image else {
			let missingInputVC = MissingInputViewController()
			missingInputVC.modalTransitionStyle = .crossDissolve
			missingInputVC.modalPresentationStyle = .overCurrentContext
			present(missingInputVC, animated: true)
			return
		}
		let eventDate = datePicker.date
		let interval = eventDate.timeIntervalSince1970
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		EventService.shared.createAndDownloadImageURL(eventImage: eventImage) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let url):
				let firestoreEvent = FirebaseEvent(userID: self.user.userID, eventTitle: eventTitle, organizerName: self.user.name, timestamp: interval,
												   location: addreddText, introText: introText, imageURL: url, participants: [self.user.userID])
				EventService.shared.uploadEvent(event: firestoreEvent) { [weak self] in
					guard let self = self else { return }
					loadingLottie.stopAnimation()
					self.dismiss(animated: true)
				}
				
			case .failure(let error):
				print(error)
			}
		}
	}
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
	
	// MARK: - Helpers
}

// MARK: - PHPickerViewControllerDelegate

extension CreateEventViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		let itemProviders = results.map(\.itemProvider)
		for item in itemProviders {
			if item.canLoadObject(ofClass: UIImage.self) {
				item.loadObject(ofClass: UIImage.self) { [weak self](image, error) in
					guard let self = self else { return }
					DispatchQueue.main.async {
						if let image = image as? UIImage {
							self.eventImageView.image = nil
							self.eventImageView.image = image
						}
					}
				}
			}
		}
	}
}
