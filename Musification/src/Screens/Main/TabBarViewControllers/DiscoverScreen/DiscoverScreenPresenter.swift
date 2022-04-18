//
//  DiscoverScreenPresenter.swift
//  Musification
//
//  Created by Георгий Рыбак on 25.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol DiscoverScreenPresentationLogic: AnyObject {
    func presentSomething(response: DiscoverScreen.Response)
}

final class DiscoverScreenPresenter {
    // MARK: - Properties
    weak var viewController: DiscoverScreenDisplayLogic?
}

// MARK: - DiscoverScreenPresentationLogic
extension DiscoverScreenPresenter: DiscoverScreenPresentationLogic {
    func presentSomething(response: DiscoverScreen.Response) {
        let viewModel = DiscoverScreen.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
