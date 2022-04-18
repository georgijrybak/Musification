//
//  StartScreenManager.swift
//  Musification
//
//  Created by Георгий Рыбак on 20.02.22.
//

import UIKit

class ScreenManager {
    static let shared = ScreenManager()

    private init() {}

    func startSplashScreen(selfWindow: inout UIWindow?) {
        let viewController = SplashScreenAssembly.assembly()
        startSomeScreen(selfWindow: &selfWindow, screenToShow: viewController)
    }

    private func startSomeScreen(selfWindow: inout UIWindow?, screenToShow: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController(rootViewController: screenToShow)
        window.rootViewController = navigation
        selfWindow = window
        window.makeKeyAndVisible()
    }
}
