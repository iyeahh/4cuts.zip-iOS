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

                guard let self else { return }

                let title = getTitle(for: row)
                cell.categoryLabel.text = title

                cell.collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)

                element
                    .bind(to: cell.collectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)) { (row, item, cell) in

                        KingfisherManager.shared.setHeaders()

                        cell.mainImageView.kf.setImage(with: item.files.first!.url)
                        cell.productTitleLabel.text = item.title
                        cell.priceLabel.text = "\(item.price!.formatted())원"

                        let observableProductId = Observable<(String, Int?)>.just((item.post_id, item.price))

                        cell.getButton.rx.tap
                            .withLatestFrom(observableProductId)
                            .subscribe(onNext: { value in
                                payTap.onNext(value)
                            })
                            .disposed(by: cell.disposeBag)
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
                            owner.makeToast(title: "결제", message: "결제가 완료되었어요!")
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
