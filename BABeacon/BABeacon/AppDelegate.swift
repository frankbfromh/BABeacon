//
//  AppDelegate.swift
//  BABeacon
//
//  Created by Frank Burgers on 24/11/16.
//  Copyright © 2016 Frank Burgers. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
		window = UIWindow()
		
		if let w = window {
			
			w.rootViewController = ViewController()
			w.makeKeyAndVisible()
		}
		
		return true
	}
}
