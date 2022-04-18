//
//  SplashScreenViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 10.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

protocol SplashScreenDisplayLogic: AnyObject {
    func displaySignInScreen()
    func displayMainScreen()
    func displayOnboardingScreen()
}

final class SplashScreenViewController: UIViewController {
    // MARK: - Nested Types
    private enum Constants {
        static let imageSize = 199
    }

    // MARK: - Properties
    private let interactor: SplashScreenBusinessLogic
    private let router: SplashScreenRoutingLogic

    // MARK: - UI Properties
    private lazy var loadingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: Constants.imageSize,
                height: Constants.imageSize
            )
        )
        return imageView
    }()

    // MARK: - Initialization
    init(interactor: SplashScreenBusinessLogic, router: SplashScreenRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented in SplashScreenViewController")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        startSettings()
    }

    // MARK: - Private Methods
    private func startSettings() {
        checkOnboardingPassed()
    }

    private func configureView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.main

        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
        view.addSubview(loadingImage)
    }

    private func setupLayout() {
        loadingImage.center = view.center
    }

    // MARK: - Interactor Methods
    func checkOnboardingPassed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut]
            ) {
                self.loadingImage.alpha = 0
            } completion: { _ in
                self.interactor.fetchFirstScreen()
            }
        }
    }
}

// MARK: - SplashScreenDisplayLogic
extension SplashScreenViewController: SplashScreenDisplayLogic {
    func displaySignInScreen() {
        router.routeToSignInScreen()
    }

    func displayMainScreen() {
        router.routeToMainScreen()
    }

    func displayOnboardingScreen() {
        router.routeToOnboardingScreen()
    }
}
