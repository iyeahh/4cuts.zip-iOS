# 🗓 포컷츠집 (4cuts.zip)
## ✌🏻 네컷 사진과 관련된 포토부스, 포즈 등을 함께 공유하는 SNS 앱
##### 프로젝트 기간: 2024년 8월 25일 → 2024년 9월 3일 (10일)
##### 인원: 기획 & 디자인 & 개발 총 1명
##### 최소 버전: iOS 17+

## 🧐 핵심 기능
* 포토부스, 배경 및 필터, 포즈 공유
* 네컷 사진 포스트
* 근처에 있는 포토부스 위치 표시
* 네컷사진과 관련된 상품 결제

## 🤓 기술 스택
* UIKit, RxSwift, RxCocoa
* MVVM - InOut, Router 패턴
* CoreLocation

## 📚 라이브러리
* NaverMapSDK
* Alamofire
* iamport_ios
* SnapKit
* Kingfisher
* Toast

## 💡 문제 해결

### ❓ 토픽
**토큰을 사용하는 API에서 토큰 만료 시 리프레시 토큰으로 토큰 갱신, 리프레시 토큰 만료 시 대응**

### ❕ 해결 방법


💡 **문제상황**: **토큰 만료 시 서버에 요청을 보내기 전에, 중간에 가로채 작업한 뒤 다시 서버로 보내는 Interceptor를 활용하여 retry 메서드로 갱신하려 했으나, retry 메서드가 무한 실행되는 문제 발생 → 어떻게 무한 실행을 멈추고 토큰 갱신을 할 수 있을까?**

- Router 패턴 & TargetType 적용으로 Router를 통해 만료된 토큰이 포함된 Request를 적용하고 있음
    - retry 메서드의 request는 토큰 갱신 전의 request를 가져오기 때문에
    - adapt 메서드에 request Header에 갱신된 토큰의 정보를 넣어주고 retry 메서드를 실행시켜야 정상적으로 작동함
- 리프레시 토큰까지 만료되면 저장되어 있던 모든 정보를 삭제하고, 로그인 화면을 띄워
    - 정상적인 로그인이 가능하다면 토큰과, 리프레시 토큰을 발급받을 수 있도록 대응
 <img width="1000" alt="스크린샷 2024-09-17 오후 1 25 50" src="https://github.com/user-attachments/assets/e693979d-4565-4cb0-9653-087beddffc4c">


------
### ❓ 토픽
**PG 결제 플로우와 영수증 검증**

### ❕ 해결 방법
💡 **문제상황:** **네컷 사진과 관련된 상품을 판매하고 싶은데 어떻게 결제 시스템을 적용시키고 실제 결제가 일어났는지 확인할 수 있을까?**

- 통합 결제 API인 포트원을 활용하여 결제대행사(PG) 연결
    - 결제 버튼을 탭했을 때 결제 정보 입력
    
    ```swift
    input.payTap
            .subscribe(with: self) { owner, value in
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))",
                    amount: "\(value.1)").then {
                        $0.pay_method = PayMethod.card.rawValue
                        $0.name = "4cut.zip"
                        $0.buyer_name = "양보라"
                        $0.app_scheme = "sesac"
                    }
                outputPayment.onNext((payment, value.0))
            }
            .disposed(by: disposeBag)
    ```
    
- 실제 결제가 되었는지 확인하기 위해
    - 결제 정보를 가지고 영수증 검증을 통해 실제 결제 내역이 있는지 확인 후
    - 유저에게 토스트 메시지를 띄워 주고 로직을 처리
```swift
output.payment
            .subscribe(with: self) { owner, payment in
                Iamport.shared.payment(viewController: owner,
                                       userCode: "imp57573124",
                                       payment: payment.0) { paymentResult in
                    NetworkManager.shared.validPayment(impUid: paymentResult.imp_uid, postId: payment.1) { value in
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
```
---
       
### ❓ 토픽
**사용자의 아이폰 자체의 위치서비스가 꺼져있거나, 앱의 위치서비스를 허용하지 않은 상태의 대응**

### ❕ 해결 방법

💡 **문제 상황**: **CoreLocation을 활용하여 사용자의 위치를 받아와 주변의 포토부스들을 표시해 주고 싶은데 위치 서비스 상태에 따라 앱이 그냥 꺼지기도 하여 상세하고 적절한 대응이 필요하고, 앱을 사용하다가 설정의 변경까지 확인하여 대응해야 하지 않을까?**

- 어떠한 이유로 현재 위치가 뜨지 않는지에 대한 자세한 이유를 토스트 메세지로 띄워주고
- 디폴트 주소를 설정하여 지도를 띄워줌
<img width="1000" alt="스크린샷 2024-09-17 오후 1 25 58" src="https://github.com/user-attachments/assets/23319c53-5390-42a7-8d49-c3d617ba73c7">


---
### ❓ 토픽
**Create와 Update를 한 메서드에서 처리하기**

### ❕ 해결 방법

💡 **문제 상황**: **글을 포스트 하거나, 수정하는 로직을 한 화면에서 구현하기 때문에 업로드 버튼이 tap 되었을 때 multipartFormData 타입으로 이미지를 올리는 것까지는 동일하나 네트워킹 하는 부분부터 분기처리가 필요한데 어떻게 최소한의 코드로 두 가지 로직을 대응할 수 있을까?**

- 이미지를 업로드하는 네트워킹을 실행하고 실패했을 때는 이미지 업로드 실패에 대한 토스트 메시지를 표시하고 성공했을 때는
    - Update의 경우에는 이미 PostId를 가지고 있기 때문에
    - PostId 유무로 분기처리하여 각각의 라우터의 request로 네트워킹 처리로
    - 한 메서드로 두 가지 로직 대응
```swift
input.uploadButtonTap
            .subscribe(with: self) { owner, contentValue in
                let imageContents = contentValue.0
                let stringContent = contentValue.1
                let postId = contentValue.2

                do {
                    AF.upload(multipartFormData: { multipartFormData in
                        imageContents.forEach { image in
                                if let convertedImage = image.jpegData(compressionQuality: 0.1) {
                                multipartFormData.append(convertedImage, withName: "files", fileName: "\(stringContent).png", mimeType: "image/png")
                            }
                        }
                    }, with: try Router.uploadPhoto.asURLRequest())
                    .responseDecodable(of: PhotoListModel.self) { [weak self] response in
                        guard let self else { return }
                        switch response.result {
                        case .success(let value):
                            Observable.just(value)
                                .flatMap { photo -> Single<Result<PostContent, NetworkError>> in
                                    if let id = postId {
                                        NetworkManager.shared.callRequestWithToken(router: .editPost(id: id, content: Content(content: stringContent, product_id: "4cut_photo", files: photo.files)))
                                    } else {
                                        NetworkManager.shared.callRequestWithToken(router: .postContent(content: Content(content: stringContent, product_id: "4cut_photo", files: photo.files)))
                                    }
                                }
                                .subscribe(with: self, onNext: { owner, value in
                                    switch value {
                                    case .success:
                                        owner.popNavi.onNext(true)
                                    case .failure:
                                        failUploadString.onNext(true)
                                    }
                                })
                                .disposed(by: self.disposeBag)
                        case .failure:
                            failUploadImage.onNext(true)
                        }
                    }
                } catch {
                    failNetworking.onNext(true)
                }

            }
            .disposed(by: disposeBag)
```
