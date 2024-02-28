//
//  ShoppingViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
import iamport_ios
import Toast

final class ShoppingViewController: BaseViewController {

    private lazy var tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = ((UIScreen.main.bounds.width - 10) / 2 * 1.3) + 50
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        return tableView
    }()

    lazy var webView = {
        let view = WKWebView()
        view.backgroundColor = .white
        return view
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
        let payTap = PublishSubject<(String, Int?)>()

        let input = ShoppingViewModel.Input(viewDidLoad: Observable.just(ShoppingCategory.allCases), payTap: payTap)

        let output = viewModel.transform(input: input)

        output.shoppingList
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { [weak self] (row, element, cell) in

                guard let shoppingCell = cell as? ShoppingTableViewCell,
                let self else {
                    return
                }

                let title = getTitle(for: row)
                shoppingCell.categoryLabel.text = title

                cell.collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)

                element
                    .bind(to: cell.collectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)) { (row, item, cell) in

                        guard let collectionViewCell = cell as? ShoppingCollectionViewCell else {
                            return
                        }

                        KingfisherManager.shared.setHeaders()

                        collectionViewCell.mainImageView.kf.setImage(with: item.files.first!.url)
                        collectionViewCell.productTitleLabel.text = item.title
                        collectionViewCell.priceLabel.text = "\(item.price!.formatted())원"

                        let observableProductId = Observable<(String, Int?)>.just((item.post_id, item.price))

                        
                        collectionViewCell.getButton.rx.tap
                            .withLatestFrom(observableProductId)
                            .subscribe(with: self, onNext: { owner, value in
                                payTap.onNext(value)
                            })
                            .disposed(by: self.disposeBag)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        output.payment
            .subscribe(with: self) { owner, payment in
                Iamport.shared.payment(viewController: owner,
                                       userCode: "imp57573124",
                                       payment: payment.0) { paymentResult in
                    NetworkManager.shared.validPayment(impUid: paymentResult!.imp_uid!, postId: payment.1) { value in
                        switch value {
                        case .success(let success):
                            self.view.makeToast("결제가 성공했습니다")
                        case .failure(let failure):
                            self.view.makeToast("결제가 실패했습니다")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    private func getTitle(for row: Int) -> String {
        switch row {
        case 0:
            return "앨범"
        case 1:
            return "액자"
        default:
            return "인생네컷"
        }
    }

}
