//
//  ShoppingViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

final class ShoppingViewController: BaseViewController {

    private lazy var tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = ((UIScreen.main.bounds.width - 10) / 2 * 1.3) + 50
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        return tableView
    }()

    let viewModel = ShoppingViewModel()
    let disposeBag = DisposeBag()

    override func configureView() {
        navigationItem.title = TabBar.shopping.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func configureHierarchy() {
        view.addSubview(tableView)
    }

    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func bind() {
        let input = ShoppingViewModel.Input(viewDidLoad: Observable.just(()))

        let output = viewModel.transform(input: input)

        output.shoppingList
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in

                guard let shoppingCell = cell as? ShoppingTableViewCell else {
                    return
                }

                var title = ""

                switch row {
                case 0:
                    title = "앨범"
                case 1:
                    title = "액자"
                case 2:
                    title = "키링"
                default:
                    title = "인생네컷"
                }

                shoppingCell.categoryLabel.text = title
                shoppingCell.collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
                element
                    .bind(to: cell.collectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)) { (row, item, cell) in

                        guard let collectionViewCell = cell as? ShoppingCollectionViewCell else {
                            return
                        }

                        let url = URL(string: item.image)
                        collectionViewCell.mainImageView.kf.setImage(with: url)
                        collectionViewCell.productTitleLabel.text = item.title.makeOnlyString
                        collectionViewCell.priceLabel.text = item.lprice.makeInt
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
}
