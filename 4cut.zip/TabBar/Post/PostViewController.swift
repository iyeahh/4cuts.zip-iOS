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

final class PostViewController: BaseViewController {

    let disposeBag = DisposeBag()

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

    let photoImageView = {
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
        button.addTarget(nil, action: #selector(uploadPhoto), for: .touchUpInside)
        return button
    }()

    override func configureView() {
        view.backgroundColor = .white
    }

    override func configureHierarchy() {
        view.addSubview(photoButton)
        view.addSubview(photoImageView)
        view.addSubview(photoImageView2)
        view.addSubview(contentTextView)
        view.addSubview(saveButton)
    }

    override func configureLayout() {
        photoButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(100)
        }

        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(photoButton.snp.trailing).offset(10)
            make.size.equalTo(100)
        }

        photoImageView2.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(photoImageView.snp.trailing).offset(10)
            make.size.equalTo(100)
        }

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(10)
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
        photoButton.rx.tap
            .subscribe(with: self) { owner, _ in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 2
                configuration.filter = .any(of: [.images, .screenshots])

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)
    }

    @objc func uploadPhoto() {
        do {
            AF.upload(multipartFormData: { multipartFormData in
                if let image = self.photoImageView.image?.jpegData(compressionQuality: 0.1) {
                    multipartFormData.append(image, withName: "files", fileName: "test.png", mimeType: "image/png")
                }
            }, with: try Router.uploadPhoto.asURLRequest())
            .responseDecodable(of: PhotoListModel.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                case .failure:
                    print("사진 업로드 실패")
                }
            }
        } catch {

        }

    }
}


extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        results.forEach { photo in
            if photo.itemProvider.canLoadObject(ofClass: UIImage.self) {
                photo.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        self.photoImageView.image = image as? UIImage
                    }
                }
            }
        }
    }
}
