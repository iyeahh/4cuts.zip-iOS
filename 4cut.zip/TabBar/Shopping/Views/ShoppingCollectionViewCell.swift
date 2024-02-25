//
//  ShoppingCollectionViewCell.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ShoppingCollectionViewCell: BaseCollectionViewCell {

    let mainImageView = UIImageView()

    let productTitleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.numberOfLines = 1
        return label
    }()

    let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .gray
        return label
    }()

    private let getButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "giftcard")
        configuration.title = "구매하기"
        configuration.titleAlignment = .center
        configuration.titlePadding = 20
        configuration.baseBackgroundColor = Constant.Color.accent
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()

    override func configureHierarchy() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(getButton)
    }

    override func configureLayout() {
        getButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(44)
        }

        priceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(getButton.snp.top).offset(-10)
            make.height.equalTo(20)
        }

        productTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(priceLabel.snp.top).offset(-10)
            make.height.equalTo(20)
        }

        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(productTitleLabel.snp.top).offset(-10)
        }
    }

}
