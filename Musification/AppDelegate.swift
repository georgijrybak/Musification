//
//  AppDelegate.swift
//  Musification
//
//  Created by Георгий Рыбак on 7.02.22.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()

        ScreenManager.shared.startSplashScreen(selfWindow: &window)

        return true
    }
}
