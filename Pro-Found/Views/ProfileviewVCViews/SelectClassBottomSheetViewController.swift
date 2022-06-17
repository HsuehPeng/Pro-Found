//
//  SelectClassBottomSheetViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit

class SelectClassBottomSheetViewController: UIViewController {
	
	// MARK: - Properties
	
	var course: Course
	var user: User
	var tutor: User
	
	var hasSetPointOrigin = false
	var pointOrigin: CGPoint?
	
	private let slideTopView: UIView = {
		let view = UIView()
		view.backgroundColor = .orange
		view.layer.cornerRadius = 2
		return view
	}()
	
	private lazy var datePicker: UIDatePicker = {
		let picker = UIDatePicker()
		picker.datePickerMode = .dateAndTime
		picker.preferredDatePickerStyle = .inline
		picker.tintColor = .orange
		picker.minuteInterval = 30
		let currentDate = Date()
		let afterThreeMonthsdate = Calendar.current.date(byAdding: .month, value: 3, to: currentDate)
		picker.maximumDate = afterThreeMonthsdate
		picker.minimumDate = currentDate
		picker.addTarget(self, action: #selector(changeDatePickerValue), for: .valueChanged)
		return picker
	}()
	
	private lazy var confirmButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .white, borderColor: .clear, buttonText: "Book Course")
		button.addTarget(self, action: #selector(confirmBookingCourse), for: .touchUpInside)
		
		return button
	}()
	
	// MARK: - Lifecycle
	
	init(user: User, course: Course, tutor: User) {
		self.user = user
		self.course = course
		self.tutor = tutor
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
		view.addGestureRecognizer(panGesture)
		view.backgroundColor = .orange10
		
		setupUI()
	}
	
	override func viewDidLayoutSubviews() {
		if !hasSetPointOrigin {
			hasSetPointOrigin = true
			pointOrigin = self.view.frame.origin
		}
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(slideTopView)
		slideTopView.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 8)
		slideTopView.setDimensions(width: view.frame.size.width * 0.2, height: 4)
		
		view.addSubview(datePicker)
		datePicker.anchor(top: slideTopView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(confirmButton)
		confirmButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
							 right: view.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
	}
	
	// MARK: - Actions
	
	@objc func changeDatePickerValue(_ sender: UIDatePicker) {

	}
	
	@objc func confirmBookingCourse() {
		guard let courseID = course.courseID else { return }
		let timeInterval = datePicker.date.timeIntervalSince1970
		print(courseID, user.userID, timeInterval)
		UserServie.shared.uploadScheduledCourse(userID: user.userID, courseID: courseID, time: timeInterval)
		dismiss(animated: true)
	}
	
	@objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: view)
		
		guard translation.y >= 0 else { return }
		
		view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
		
		if sender.state == .ended {
			let dragVelocity = sender.velocity(in: view)
			if dragVelocity.y >= 1300 {
				self.dismiss(animated: true, completion: nil)
			} else {
				UIView.animate(withDuration: 0.3) {
					self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
				}
			}
		}
	}

}
