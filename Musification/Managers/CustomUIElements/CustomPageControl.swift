//
//  UIView+CustomPageControl.swift
//  Musification
//
//  Created by Георгий Рыбак on 10.02.22.
//

import UIKit

class CustomPageControl: UIView {
    private let contentView = UIView()
    private let controlStrip = UIView()

    var pageCount: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        setupLayout()
    }

    private func setupLayout() {
        addSubview(contentView)

        contentView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }

        guard let pages = pageCount else { return }

        let widthSize = bounds.width / CGFloat(pages + 1)
        let dotSise = widthSize / 3

        for dotState in 0...pages {
            let dotView = UIView()
            let dot = UIView()

            contentView.addSubview(dotView)
            dotView.addSubview(dot)

            dotView.snp.makeConstraints { maker in
                maker.width.equalTo(widthSize)
                maker.top.bottom.equalToSuperview()
                maker.left.equalToSuperview().offset((CGFloat(dotState) * widthSize))
            }

            dot.snp.makeConstraints { maker in
                maker.centerY.centerX.equalToSuperview()
                maker.height.width.equalTo(widthSize / 3)
            }

            dot.layer.cornerRadius = widthSize / 6
            dot.backgroundColor = .gray
        }

        contentView.addSubview(controlStrip)

        controlStrip.snp.makeConstraints { maker in
            maker.centerX.equalTo(contentView.snp.left).offset(widthSize)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(dotSise)
            maker.width.equalTo(widthSize + dotSise)
        }

        controlStrip.backgroundColor = .white
        controlStrip.layer.cornerRadius = dotSise / 2
    }

    func translateXControlStrip(superViewTranslation: CGFloat) {
        guard let pages = pageCount, let superview = superview else { return }

        let widthSize = bounds.width / CGFloat(pages + 1)

        let diffScale = superViewTranslation * (widthSize / superview.frame.width)

        let newTransform = CGAffineTransform(translationX: diffScale, y: 0)
        controlStrip.transform = newTransform
    }
}
