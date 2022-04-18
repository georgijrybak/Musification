//
//  DiscoverScreenRouter.swift
//  Musification
//
//  Created by Георгий Рыбак on 25.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol DiscoverScreenRoutingLogic: AnyObject {
    func back()
}

final class DiscoverScreenRouter: DiscoverScreenRoutingLogic {
    // MARK: - Properties
    weak var viewController: DiscoverScreenViewController?

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
