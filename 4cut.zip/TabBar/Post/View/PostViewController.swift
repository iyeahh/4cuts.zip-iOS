//
//  PostViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI
import Alamofire
import Kingfisher

final class PostViewController: BaseViewController {

    let disposeBag = DisposeBag()
    let viewModel = PostViewModel()
    let imageSubject = PublishSubject<[UIImage]>()

    var postContent: PostContent?

    let photoButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "사진 추가"
        configuration.titleAlignment = .center
        configuration.titlePadding = 20
        configuration.cornerStyle = .medium
        configuration.buttonSize = .medium
        button.configuration = configuration
        return button
    }()

    let photoImageView1 = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()

    let photoImageView2 = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()

    let contentTextView = {
        let textView = UITextView()
        textView.text = "#부스추천 여기 어때?"
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        return textView
    }()

    let saveButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "새 글 올리기"
        configuration.titleAlignment = .center
        configuration.titlePadding = 20
        configuration.cornerStyle = .medium
        configuration.buttonSize = .medium
        button.configuration = configuration
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let postContent else { return }
        KingfisherManager.shared.setHeaders()

        photoImageView1.kf.setImage(with: postContent.files[0].url)
        contentTextView.text = postContent.content
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }

    override func configureView() {
        view.backgroundColor = .white
    }

    override func configureHierarchy() {
        view.addSubview(photoButton)
        view.addSubview(photoImageView1)
        view.addSubview(photoImageView2)
        view.addSubview(contentTextView)
        view.addSubview(saveButton)
    }

    override func configureLayout() {
        photoButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(100)
        }

        photoImageView1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(photoButton.snp.trailing).offset(10)
            make.size.equalTo(100)
        }

        photoImageView2.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(photoImageView1.snp.trailing).offset(10)
            make.size.equalTo(100)
        }

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView1.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(contentTextView.snp.width).dividedBy(2)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
    }

    override func bind() {
        let textObservable = contentTextView.rx.text.orEmpty
        let isEditObservable = Observable.just(postContent?.post_id)
        let contentZip = Observable.combineLatest(imageSubject, textObservable, isEditObservable)

        let input = PostViewModel.Input(
            photoButtonTap: photoButton.rx.tap,
            uploadButtonTap: saveButton.rx.tap
                .withLatestFrom(contentZip)
        )

        let output = viewModel.transform(input: input)

        output.photoButtonTap
            .subscribe(with: self) { owner, _ in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 2
                configuration.filter = .any(of: [.images, .screenshots])

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)

        output.popNavi
            .subscribe(with: self) { owner, value in
                if value {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }

}

extension PostViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let imageViewList = [photoImageView1, photoImageView2]
        var imageList: [UIImage] = []
        var num = 0

        results.forEach { photo in
            if photo.itemProvider.canLoadObject(ofClass: UIImage.self) {
                photo.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        imageViewList[num].image = image as? UIImage
                        imageList.append(image as! UIImage)
                        imageSubject.onNext(imageList)
                        num += 1
                    }
                }
            }
        }
    }

}
