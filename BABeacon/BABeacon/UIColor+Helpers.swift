//
//  UIColor+Helpers.swift
//  BABeacon
//
//  Created by Frank Burgers on 24/11/16.
//  Copyright © 2016 Frank Burgers. All rights reserved.
//

import UIKit

extension UIColor
{
	convenience init(hex: Int)
	{
		let components = (
			R: CGFloat((hex >> 16) & 0xff) / 255,
			G: CGFloat((hex >> 08) & 0xff) / 255,
			B: CGFloat((hex >> 00) & 0xff) / 255
		)
		
		self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
	}
	
	convenience init(hexString: String)
	{
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 1.0
		
		if hexString.hasPrefix("#") {
			
			let index = hexString.index(hexString.startIndex, offsetBy: 1)
			let hex = String(hexString.suffix(from: index))
			let scanner = Scanner(string: hex)
			
			var hexValue: CUnsignedLongLong = 0
			
			if scanner.scanHexInt64(&hexValue) {
				
				switch (hex.count) {
					
				case 3:
					red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
					green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
					blue = CGFloat(hexValue & 0x00F) / 15.0
					
				case 4:
					red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
					green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
					blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
					alpha = CGFloat(hexValue & 0x000F) / 15.0
					
				case 6:
					red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
					green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
					blue = CGFloat(hexValue & 0x0000FF) / 255.0
					
				case 8:
					red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
					green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
					blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
					alpha = CGFloat(hexValue & 0x000000FF) / 255.0
					
				default:
					break
				}
			}
		}
		
		self.init(red:red, green:green, blue:blue, alpha:alpha)
	}
}
