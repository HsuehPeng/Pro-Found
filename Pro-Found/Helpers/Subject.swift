//
//  Subject.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import UIKit

enum Subject: String, CaseIterable {
	case language = "Language"
	case technology = "Technology"
	case music = "Music"
	case art = "Art"
	case sport = "Sport"
	case student = "Student"
	
	var image: UIImage? {
		switch self {
		case .language:
			return UIImage.asset(.language)
		case .technology:
			return UIImage.asset(.technology)
		case .music:
			return UIImage.asset(.music)
		case .art:
			return UIImage.asset(.art)
		case .sport:
			return UIImage.asset(.sport)
		case .student:
			return nil
		}
	}
	
	var subjectButtonColor: UIColor? {
		switch self {
		case .language:
			return UIColor.orange
		case .technology:
			return UIColor.skyBlue
		case .music:
			return UIColor.green
		case .art:
			return UIColor.yellow
		case .sport:
			return UIColor.dark40
		case .student:
			return UIColor.light
		}
	}
	
	var subjectTutorProfileColor: UIColor? {
		switch self {
		case .language:
			return UIColor.orange10
		case .technology:
			return UIColor.skyBlue10
		case .music:
			return UIColor.green10
		case .art:
			return UIColor.yellow10
		case .sport:
			return UIColor.dark10
		case .student:
			return UIColor.light50
		}
	}

}

func setSubjectButtonColor(subject: String, targetView: UIView) {
	switch subject {
	case Subject.language.rawValue:
		targetView.backgroundColor = Subject.language.subjectButtonColor
	case Subject.technology.rawValue:
		targetView.backgroundColor = Subject.technology.subjectButtonColor
	case Subject.music.rawValue:
		targetView.backgroundColor = Subject.music.subjectButtonColor
	case Subject.art.rawValue:
		targetView.backgroundColor = Subject.art.subjectButtonColor
	case Subject.sport.rawValue:
		targetView.backgroundColor = Subject.sport.subjectButtonColor
	case Subject.student.rawValue:
		targetView.backgroundColor = Subject.student.subjectButtonColor
	default:
		break
	}
}

func setTutorProfileColor(subject: String, targetView: UIView) {
	switch subject {
	case Subject.language.rawValue:
		targetView.backgroundColor = Subject.language.subjectTutorProfileColor
	case Subject.technology.rawValue:
		targetView.backgroundColor = Subject.technology.subjectTutorProfileColor
	case Subject.music.rawValue:
		targetView.backgroundColor = Subject.music.subjectTutorProfileColor
	case Subject.art.rawValue:
		targetView.backgroundColor = Subject.art.subjectTutorProfileColor
	case Subject.sport.rawValue:
		targetView.backgroundColor = Subject.sport.subjectTutorProfileColor
	case Subject.student.rawValue:
		targetView.backgroundColor = Subject.student.subjectTutorProfileColor
	default:
		break
	}
}
