//
//  NotificationView.swift
//  Musification
//
//  Created by Георгий Рыбак on 17.02.22.
//

import UIKit
import SnapKit

enum NotificationType {
    case error
    case success
}

class NotificationView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let lifelongTimeForError: Double = 1
        static let lifelongTimeForSuccess: Double = 3
        static let offset = 16
    }
    // MARK: - UI property
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.3
        return view
    }()

    private lazy var notificationMessage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let notificationImage = UIImageView()
    private let notificationView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews([contentView, notificationView])
        notificationView.addSubviews([notificationMessage, notificationImage])

        contentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        notificationView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(90)
        }
        notificationImage.snp.makeConstraints { maker in
            maker.height.width.equalTo(30)
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(Constants.offset)
        }
        notificationMessage.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(notificationImage.snp.right).offset(Constants.offset)
            maker.height.equalTo(60)
            maker.right.equalToSuperview().offset(-Constants.offset)
        }
        isHidden = true
        alpha = 0
    }

    func showNotification(type: NotificationType, message: String, completion: (() -> Void)?) {
        switch type {
        case .error:
            notificationMessage.text = message
            notificationMessage.textColor = .white
            notificationView.backgroundColor = Color.error
            notificationImage.image = UIImage(named: "notification")
            presentWithAnimation(lifeLong: Constants.lifelongTimeForError, completion: completion)
        case .success:
            notificationMessage.text = message
            notificationMessage.textColor = .black
            notificationView.backgroundColor = .white
            notificationImage.image = UIImage(named: "notification(black)")
            presentWithAnimation(lifeLong: Constants.lifelongTimeForSuccess, completion: completion)
        }
    }

    private func presentWithAnimation(lifeLong: Double, completion: (() -> Void)? ) {
        self.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        } completion: { _ in
            self.hideWithAnimation(lifeLong: lifeLong, completion: completion)
        }
    }

    private func hideWithAnimation(lifeLong: Double, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, delay: lifeLong) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
            if let completion = completion { completion() }
        }
    }
}
