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
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = Constant.Color.secondaryLightPink.cgColor
        return imageView
    }()

    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }

    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

}
