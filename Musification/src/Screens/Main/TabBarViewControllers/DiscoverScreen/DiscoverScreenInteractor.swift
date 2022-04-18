//
//  DiscoverScreenInteractor.swift
//  Musification
//
//  Created by Георгий Рыбак on 25.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol DiscoverScreenBusinessLogic: AnyObject {
    func doSomething(request: DiscoverScreen.Request)
}

final class DiscoverScreenInteractor {
    // MARK: - Properties
    private let presenter: DiscoverScreenPresentationLogic
    private let worker: DiscoverScreenWorker

    // MARK: - Initialization
    init(presenter: DiscoverScreenPresentationLogic, worker: DiscoverScreenWorker) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - DiscoverScreenBusinessLogic
extension DiscoverScreenInteractor: DiscoverScreenBusinessLogic {
    func doSomething(request: DiscoverScreen.Request) {
        let response = DiscoverScreen.Response()
        presenter.presentSomething(response: response)
    }
}
