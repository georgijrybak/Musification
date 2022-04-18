//
//  DiscoverScreenViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 25.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DiscoverScreenDisplayLogic: AnyObject {
    func displaySomething(viewModel: DiscoverScreen.ViewModel)
}

final class DiscoverScreenViewController: UIViewController {
    // MARK: - Nested Types
    private enum Constants {
        static let offset = 1
    }

    // MARK: - Properties
    private let interactor: DiscoverScreenBusinessLogic
    private let router: DiscoverScreenRoutingLogic

    // MARK: - UI Properties
    let segmentControl: UISegmentedControl = {
        let element = UISegmentedControl()
//        element.
        return element
    }()

    // MARK: - Initialization
    init(interactor: DiscoverScreenBusinessLogic, router: DiscoverScreenRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented in DiscoverScreenViewController")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        startSettings()
    }

    // MARK: - Private Methods
    private func startSettings() {
        doSomething()
    }

    private func configureView() {
        navigationController?.title = "discover".localized(withComment: nil)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = Color.main

        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
    }

    private func setupLayout() {
    }

    // MARK: - Interactor Methods
    func doSomething() {
        let request = DiscoverScreen.Request()
        interactor.doSomething(request: request)
    }
}

// MARK: - DiscoverScreenDisplayLogic
extension DiscoverScreenViewController: DiscoverScreenDisplayLogic {
    func displaySomething(viewModel: DiscoverScreen.ViewModel) {
    }
}
