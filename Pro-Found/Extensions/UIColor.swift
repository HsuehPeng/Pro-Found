//
//  UIColor.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/12.
//

import UIKit

private enum STColor: String {
	
	case ocean
	case ocean10
	case ocean20
	case ocean30
	case ocean40
	case ocean50
	case ocean60
}

extension UIColor {
	
	static let ocean = STColor(.ocean)
	static let ocean10 = STColor(.ocean10)
	static let ocean20 = STColor(.ocean20)
	static let ocean30 = STColor(.ocean30)
	static let ocean40 = STColor(.ocean40)
	static let ocean50 = STColor(.ocean50)
	static let ocean60 = STColor(.ocean60)
	
	private static func STColor(_ color: STColor) -> UIColor? {

		return UIColor(named: color.rawValue)
	}
	
	static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
		return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
	}
	
	static func hexStringToUIColor(hex: String) -> UIColor {

		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

		if cString.hasPrefix("#") {
			cString.remove(at: cString.startIndex)
		}

		if (cString.count) != 6 {
			return UIColor.gray
		}

		var rgbValue: UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)

		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}
