//
//  PinterestCollectionViewCell.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/27/24.
//

import UIKit
import SnapKit

final class PinterestCollectionViewCell: BaseCollectionViewCell {

    let imageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = Constant.Color.secondaryLightPink.cgColor
        return imageView
    }()

    let emojiLabel = {
        let label = UILabel()
        label.text = "🤍"
        return label
    }()

    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(emojiLabel)
    }

    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(contentView)
            make.top.equalToSuperview().inset(5)
        }

        emojiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(imageView.snp.width).dividedBy(5)
            make.height.equalTo(emojiLabel.snp.width)
            make.trailing.equalToSuperview().inset(5)
        }
    }

}
