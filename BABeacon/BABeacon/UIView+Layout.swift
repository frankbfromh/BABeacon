//
//  UIView+Layout.swift
//  BABeacon
//
//  Created by Frank Burgers on 24/11/16.
//  Copyright © 2016 Frank Burgers. All rights reserved.
//

import UIKit

protocol MarginElement
{
	var margins: UIEdgeInsets? {get}
}

extension UIView
{
	func layoutAnchorTop(_ margin: Double = 0, priority: UILayoutPriority = UILayoutPriority.required) -> [NSLayoutConstraint]?
	{
		return applyVisualFormat("V:|-(\(margin)@\(priority.rawValue))-[self]")
	}
	
	func layoutAnchorBottom(_ margin: Double = 0, priority: UILayoutPriority = UILayoutPriority.required) -> [NSLayoutConstraint]?
	{
		return applyVisualFormat("V:[self]-(\(margin)@\(priority.rawValue))-|")
	}
	
	func layoutAnchorRight(_ margin: Double = 0, priority: UILayoutPriority = UILayoutPriority.required) -> [NSLayoutConstraint]?
	{
		return applyVisualFormat("H:[self]-(\(margin)@\(priority.rawValue))-|")
	}
	
	func layoutAnchorLeft(_ margin: Double = 0, priority: UILayoutPriority = UILayoutPriority.required) -> [NSLayoutConstraint]?
	{
		return applyVisualFormat("H:|-(\(margin)@\(priority.rawValue))-[self]")
	}
}

extension UIView
{
	func layoutMatchHeightToWidth(_ view: UIView, multiplier: CGFloat = 1.0) -> [NSLayoutConstraint]
	{
		let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: multiplier, constant: 0)
		
		if let s = self.superview {
			s.addConstraint(constraint)
		}
		
		return [constraint]
	}
	
	func layoutMatchWidthToheight(_ view: UIView, multiplier: CGFloat = 1.0) -> [NSLayoutConstraint]
	{
		let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: multiplier, constant: 0)
		
		if let s = self.superview {
			s.addConstraint(constraint)
		}
		
		return [constraint]
	}
	
	func layoutMatchCenterX(_ view: UIView) -> [NSLayoutConstraint]
	{
		let constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
		
		if let s = self.superview {
			s.addConstraint(constraint)
		}
		
		return [constraint]
	}
	
	func layoutMatchCenterY(_ view: UIView) -> [NSLayoutConstraint]
	{
		let constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
		
		if let s = self.superview {
			s.addConstraint(constraint)
		}
		
		return [constraint]
	}
	
	func layoutMatchBottomY(_ view: UIView) -> [NSLayoutConstraint]
	{
		let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		if let s = self.superview {
			s.addConstraint(constraint)
		}
		
		return [constraint]
	}
	
	func layoutMatchLeft(_ view: UIView) -> [NSLayoutConstraint]
	{
		let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
		
		if let s = self.superview {
			s.addConstraint(constraint)
		}
		
		return [constraint]
	}
}

extension UIView
{
	func clearConstraints()
	{
		self.removeConstraints(self.constraints)
	}
	
	func layoutFullWidth(_ leftMargin: CGFloat = 0.0, rightMargin: CGFloat = 0.0) -> [NSLayoutConstraint]?
	{
		return applyVisualFormat("H:|-(\(leftMargin))-[self]-(\(rightMargin))-|")
	}
	
	func layoutHeight(_ height: Double) -> [NSLayoutConstraint]?
	{
		return applyVisualFormat("V:[self(\(height))]")
	}
	
	func layoutFullHeight(_ topMargin: CGFloat = 0.0, bottomMargin: CGFloat = 0.0) -> [NSLayoutConstraint]?
	{
		return applyVisualFormat("V:|-(\(topMargin))-[self]-(\(bottomMargin))-|")
	}
	
	fileprivate func applyVisualFormat(_ format: String) -> [NSLayoutConstraint]?
	{
		if let s = self.superview {
			
			if let constraints = VisualFormat(format, views: ["self" : self]) {
				
				s.addConstraints(constraints)
				return constraints
			}
		}
		
		return nil
	}
	
	func layoutFillSuperview(_ margin: CGFloat = 0) -> [NSLayoutConstraint]?
	{
		var combinedConstraints = [NSLayoutConstraint]()
		
		if let widthConstraints = layoutFullWidth(margin, rightMargin: margin) {
			combinedConstraints += widthConstraints
		}
		
		if let heightConstraints = layoutFullHeight(margin, bottomMargin: margin) {
			combinedConstraints += heightConstraints
		}
		
		return combinedConstraints
	}
	
	func layoutSize(_ size: Double = 0) -> [NSLayoutConstraint]?
	{
		var combinedConstraints = [NSLayoutConstraint]()
		
		if let widthConstraints = layoutWidth(size) {
			combinedConstraints += widthConstraints
		}
		
		if let heightConstraints = layoutHeight(size) {
			combinedConstraints += heightConstraints
		}
		
		return combinedConstraints
	}
	
	
	func layoutWidth(_ width: Double) -> [NSLayoutConstraint]?
	{
		return applyVisualFormat("H:[self(\(width))]")
	}
	
	func layoutCenterHorizontally() -> [NSLayoutConstraint]?
	{
		if let s = self.superview {
			
			let centerXConstraint = NSLayoutConstraint(item: self,
													   attribute: NSLayoutAttribute.centerX,
													   relatedBy: NSLayoutRelation.equal,
													   toItem: s,
													   attribute: NSLayoutAttribute.centerX,
													   multiplier: 1.0,
													   constant: 0.0)
			
			s.addConstraint(centerXConstraint)
			
			return [centerXConstraint]
		}
		
		return nil
	}
	
	func layoutCenterVertically() -> [NSLayoutConstraint]?
	{
		if let s = self.superview {
			
			let centerYConstraint = NSLayoutConstraint(item: self,
													   attribute: NSLayoutAttribute.centerY,
													   relatedBy: NSLayoutRelation.equal,
													   toItem: s,
													   attribute: NSLayoutAttribute.centerY,
													   multiplier: 1.0,
													   constant: 0.0)
			
			s.addConstraint(centerYConstraint)
			
			return [centerYConstraint]
		}
		
		return nil
	}
	
	func layoutSubviewsHorizontal(_ views: [UIView]?, startMargin: CGFloat = 0, endMargin: CGFloat = 0, margin: CGFloat = 0, capEnd: Bool = true, formatOptions: NSLayoutFormatOptions = NSLayoutFormatOptions()) -> [NSLayoutConstraint]?
	{
		return layoutSubviewsLineair(views, startMargin: startMargin, endMargin: endMargin, margin: margin, orientation: "H", capEnd: capEnd, formatOptions: formatOptions)
	}
	
	func layoutSubviewsVertical(_ views: [UIView], topMargin: CGFloat = 0, bottomMargin: CGFloat = 0, margin: CGFloat = 0, capEnd: Bool = true, formatOptions: NSLayoutFormatOptions = NSLayoutFormatOptions()) -> [NSLayoutConstraint]?
	{
		return layoutSubviewsLineair(views, startMargin: topMargin, endMargin: bottomMargin, margin: margin, orientation: "V", capEnd: capEnd, formatOptions: formatOptions)
	}
	
	fileprivate func layoutSubviewsLineair(_ views: [UIView]?, startMargin: CGFloat = 0, endMargin: CGFloat = 0, margin: CGFloat = 0, orientation: String, capEnd: Bool = true, formatOptions: NSLayoutFormatOptions = NSLayoutFormatOptions()) -> [NSLayoutConstraint]?
	{
		guard let views = views else {
			return nil
		}
		
		if views.count == 0 {
			return nil
		}
		
		var viewDictionary = [String :UIView]()
		var vflStrings = [String]()
		
		for i in 0 ..< views.count {
			
			let view = views[i]
			viewDictionary["view\(i)"] = view
			vflStrings.append("[view\(i)]")
		}
		
		var stringSeperator = ""
		
		if margin > 0 {
			stringSeperator = "-\(margin)-"
		}
		
		var vfl = "\(orientation):|-\(startMargin)-"
		
		for (index, vflString) in vflStrings.enumerated() {
			
			if let customMargins = (views[index] as? MarginElement)?.margins {
				vfl += orientation == "V" ? "-\(customMargins.top)-" : "-\(customMargins.left)-"
				vfl += vflString
			}
			else if index == 0 {
				vfl += vflString
			}
			else {
				vfl += stringSeperator+vflString
			}
		}
		
		if capEnd {
			vfl += "-\(endMargin)-|"
		}
		
		if let constraints = VisualFormat(vfl, options: formatOptions, views: viewDictionary) {
			
			self.addConstraints(constraints)
			return constraints
		}
		
		return nil
	}
}

func VisualFormat(_ format: String, options: NSLayoutFormatOptions = NSLayoutFormatOptions(), views: [String : AnyObject]) -> [NSLayoutConstraint]?
{
	return NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: nil, views: views) as [NSLayoutConstraint]
}

extension NSLayoutConstraint
{
	class func constraintForMatchingBounds(_ view: UIView, matchedView: UIView) -> [NSLayoutConstraint]?
	{
		let constraints = [NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: matchedView, attribute: .leading, multiplier: 1.0, constant: 0),
						   NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: matchedView, attribute: .trailing, multiplier: 1.0, constant: 0),
						   NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: matchedView, attribute: .top, multiplier: 1.0, constant: 0),
						   NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: matchedView, attribute: .bottom, multiplier: 1.0, constant: 0)]
		
		return constraints
	}
	
	class func constraintsWithVisualFormat(_ format: String, views: [String : AnyObject]) -> [NSLayoutConstraint]?
	{
		return self.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: views) as [NSLayoutConstraint]
	}
	
	class func constraintsWithVisualFormat(_ format: String, options: NSLayoutFormatOptions, views: [String : AnyObject]) -> [NSLayoutConstraint]?
	{
		return self.constraints(withVisualFormat: format, options: options, metrics: nil, views: views) as [NSLayoutConstraint]
	}
	
	class func constraintsForCentering(_ view: UIView, inView: UIView) -> [NSLayoutConstraint]?
	{
		let centerYConstraint = NSLayoutConstraint(item: view,
												   attribute: NSLayoutAttribute.centerY,
												   relatedBy: NSLayoutRelation.equal,
												   toItem: inView,
												   attribute: NSLayoutAttribute.centerY,
												   multiplier: 1.0,
												   constant: 0.0)
		
		let centerXConstraint = NSLayoutConstraint(item: view,
												   attribute: NSLayoutAttribute.centerX,
												   relatedBy: NSLayoutRelation.equal,
												   toItem: inView,
												   attribute: NSLayoutAttribute.centerX,
												   multiplier: 1.0,
												   constant: 0.0)
		
		return [centerXConstraint, centerYConstraint]
	}
}

