//
//  OnboardingViewController.swift
//  Musification
//
//  Created by Георгий Рыбак on 9.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

protocol OnboardingDisplayLogic: AnyObject {
    func displayScrolling()
    func displayLoginScreen()
}

final class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - Nested Types
    private enum Constants {
        static let topOffset = 20
        static let imageHeight = 70
        static let edgesIndent = 32
        static let nextButtonSize = (width: 131, height: 46)
        static let skipButtonSize = (width: 40, height: 30)
        static let fontSize = 24
        static let numberOfLines = 0
        static let scrollViewDivide = 6
    }

    // MARK: - Properties
    private let interactor: OnboardingBusinessLogic
    private let router: OnboardingRoutingLogic

    // MARK: - UI Properties
    private let contentView = UIView()
    private let customPageControl: CustomPageControl = {
        let view = CustomPageControl(frame: .zero)
        view.pageCount = 3
        return view
    }()
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    private let musicFolderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "music-folder")
        return imageView
    }()
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "like")
        return imageView
    }()
    private let earphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "earphone")
        return imageView
    }()
    private let musicFolderLabel: UILabel = {
        let label = UILabel()
        label.text = "musicFolderLabel".localized(withComment: nil)
        label.font = UIFont(name: "Helvetica-Bold", size: CGFloat(Constants.fontSize))
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = Constants.numberOfLines
        return label
    }()
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "likeLabel".localized(withComment: nil)
        label.font = UIFont(name: "Helvetica-Bold", size: CGFloat(Constants.fontSize))
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = Constants.numberOfLines
        return label
    }()
    private let earphoneLabel: UILabel = {
        let label = UILabel()
        label.text = "earphoneLabel".localized(withComment: nil)
        label.font = UIFont(name: "Helvetica-Bold", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = Constants.numberOfLines
        return label
    }()
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("skip".localized(withComment: nil), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("next".localized(withComment: nil), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = UIColor(named: "Accent")?.cgColor
        button.layer.cornerRadius = 23
        return button
    }()

    // MARK: - Initialization
    init(interactor: OnboardingBusinessLogic, router: OnboardingRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented in OnboardingViewController")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        startSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animatedAppearing()
    }

    // MARK: - Private Methods
    private func startSettings() {
        setOnboardingPassed()
    }

    private func configureView() {
        view.backgroundColor = Color.main

        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
        view.addSubviews([customPageControl, scrollView, skipButton, nextButton])
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            [
                musicFolderImageView,
                likeImageView,
                earphoneImageView,
                musicFolderLabel,
                likeLabel,
                earphoneLabel
            ]
        )

        nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
        skipButton.addTarget(
            self,
            action: #selector(skipButtonTapped),
            for: .touchUpInside
        )

        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        contentView.backgroundColor = Color.main

        view.subviews.forEach {
            $0.alpha = 0
        }
    }

    private func setupLayout() {
        contentView.frame = CGRect(
            origin: CGPoint(
                x: 0,
                y: view.frame.size.height / 5
            ), size: CGSize(
                width: view.frame.size.width * 3,
                height: view.safeAreaLayoutGuide.layoutFrame.size.height / 2
            )
        )

        customPageControl.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(contentView.snp.bottom)
            maker.height.equalTo(30)
            maker.width.equalTo(view.frame.width / 4)
        }
        customPageControl.layoutIfNeeded()

        scrollView.snp.makeConstraints { maker in
            maker.centerX.width.top.bottom.equalToSuperview()
        }
        musicFolderImageView.snp.makeConstraints { maker in
            maker.centerX.equalTo(contentView.snp.leading)
                .offset(
                    contentView.frame.size.width / CGFloat(Constants.scrollViewDivide)
                )
            maker.bottom.equalTo(contentView.snp.centerY)
        }
        musicFolderLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(musicFolderImageView.snp.centerX)
            maker.width.equalTo(view.frame.width - CGFloat(Constants.edgesIndent))
            maker.top.equalTo(musicFolderImageView.snp.bottom).offset(Constants.topOffset)
            maker.height.equalTo(Constants.imageHeight)
        }
        likeImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(contentView.snp.centerY)
        }
        likeLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(likeImageView.snp.centerX)
            maker.width.equalTo(view.frame.width - CGFloat(Constants.edgesIndent))
            maker.top.equalTo(likeImageView.snp.bottom).offset(Constants.topOffset)
            maker.height.equalTo(Constants.imageHeight)
        }
        earphoneImageView.snp.makeConstraints { maker in
            maker.centerX.equalTo(contentView.snp.trailing)
                .offset(
                    -(contentView.frame.size.width / CGFloat(Constants.scrollViewDivide))
                )
            maker.bottom.equalTo(contentView.snp.centerY)
        }
        earphoneLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(earphoneImageView.snp.centerX)
            maker.width.equalTo(view.frame.width - CGFloat(Constants.edgesIndent))
            maker.top.equalTo(earphoneImageView.snp.bottom).offset(Constants.topOffset)
            maker.height.equalTo(Constants.imageHeight)
        }
        nextButton.snp.makeConstraints { maker in
            maker.bottom.equalTo(view.snp.bottom).inset(40)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(Constants.nextButtonSize.width)
            maker.height.equalTo(Constants.nextButtonSize.height)
        }
        skipButton.snp.makeConstraints { maker in
            maker.width.equalTo(Constants.skipButtonSize.width)
            maker.height.equalTo(Constants.skipButtonSize.height)
            maker.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        scrollView.contentSize = CGSize(
            width: contentView.frame.width,
            height: contentView.frame.height
        )
    }

    private func animatedAppearing() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut]
        ) {
            self.view.subviews.forEach {
                $0.alpha = 1
            }
        }
    }

    // MARK: - Interactor Methods
    private func setOnboardingPassed() {
        interactor.setUnboardingPassed()
    }

    @objc private func skipButtonTapped() {
        interactor.fetchSkipButtonCondition()
    }

    @objc private func nextButtonTapped() {
        interactor.fetchNextButtonCondition()
    }

    // MARK: - ScrollViewMethods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            scrollView.contentOffset.x < 0
                || scrollView.contentOffset.x > (view.frame.width * 2)
        else {
            let diffScale = scrollView.contentOffset.x
            customPageControl.translateXControlStrip(superViewTranslation: diffScale)
            return
        }
    }
}

// MARK: - OnboardingDisplayLogic
extension OnboardingViewController: OnboardingDisplayLogic {
    func displayLoginScreen() {
        router.routeToLogin()
    }

    func displayScrolling() {
        if scrollView.contentOffset.x == 2 * self.view.bounds.width {
            router.routeToLogin()
        } else {
            UIView.animate(withDuration: 0.25) {
                self.scrollView.contentOffset.x += self.view.bounds.width
            }
        }
    }
}
