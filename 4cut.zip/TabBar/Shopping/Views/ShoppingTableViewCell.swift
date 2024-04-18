//
//  ShoppingTableViewCell.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import UIKit
import SnapKit
import RxSwift

final class ShoppingTableViewCell: BaseTableViewCell {

    let categoryLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 10) / 3
        layout.itemSize = CGSize(width: width, height: width * 2)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return layout
    }

    override func configureHierarchy() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(collectionView)
    }

    override func configureLayout() {
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
        }

        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
        }
    }
    
}
