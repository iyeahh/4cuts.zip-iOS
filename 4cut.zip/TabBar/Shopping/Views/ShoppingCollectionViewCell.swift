//
//  ShoppingCollectionViewCell.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift

final class ShoppingCollectionViewCell: BaseCollectionViewCell {

    let mainImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

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

    let getButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "giftcard")
        configuration.title = "구매하기"
        configuration.titleAlignment = .center
        configuration.imagePadding = 5
        configuration.baseBackgroundColor = Constant.Color.secondaryPink
        configuration.baseForegroundColor = Constant.Color.accent
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .mini
        button.configuration = configuration
        return button
    }()

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func configureHierarchy() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(getButton)
    }

    override func configureLayout() {
        getButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(30)
        }

        priceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(getButton.snp.top).offset(-10)
        }

        productTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(priceLabel.snp.top).offset(-10)
        }

        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(productTitleLabel.snp.top).offset(-10)
        }
    }

}
