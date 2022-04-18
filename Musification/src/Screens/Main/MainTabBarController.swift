//
//  MainTabBarController.swift
//  Musification
//
//  Created by Георгий Рыбак on 21.02.22.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        setupVCs()
    }

    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        rootViewController.navigationController?.navigationBar.barTintColor = Color.main
        rootViewController.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        return navController
    }

    private func setupVCs() {
        UITabBar.appearance().barTintColor = Color.main
        tabBar.tintColor = .white

        viewControllers = [
            createNavController(
                for: DiscoverScreenAssembly.assembly(), // DiscoverViewController(),
                title: "discover".localized(withComment: nil),
                image: UIImage(systemName: "magnifyingglass") ?? UIImage()
            )
        ]
    }
}
