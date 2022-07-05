//
//  PolicyType.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/5.
//

enum PolicyType {
	
	case privacyPolicy
	
	case eula
	
	var url: String {
		
		switch self {
			
		case .privacyPolicy:
			return "https://pages.flycricket.io/lightening-0/privacy.html"
			
		case .eula:
			return "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
		}
	}
}
