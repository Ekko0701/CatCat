//
//  MyViewController.swift
//  CatCat
//
//  Created by Ekko on 2022/09/11.
//

import UIKit
import Alamofire
import PhotosUI
import SDWebImage
import CHTCollectionViewWaterfallLayout

class MyViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    var imageToUpload: UIImage?
    var imageToUploadCamera: UIImage?
    
    var page = 0
    var limit = 10
    
    var catArray = [Cats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyViewController - viewDidLoad()")
        setUpView()
        setUpCollectionView()
        requestUploadedCat(page: page, limit: limit)
    }
    
    func setUpView() {
        view.backgroundColor = .bgBlack
    }
    
    func setUpCollectionView() {
        myCollectionView.backgroundColor = .bgBlack
        
        // Attach CollectionView Delegate & Datasource
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        // Nib Register
        myCollectionView.register(UINib(nibName: "MyCatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER.MY_CAT_CELL)
        myCollectionView.register(UINib(nibName: "UploadCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER.UPLOAD_CELL)
        
        // SetUp Layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        self.myCollectionView.collectionViewLayout = layout
    }
    
    // MARK: .GET Uploaded Cats
    func requestUploadedCat(page: Int, limit: Int) {
        var urlToCall: URLRequestConvertible?
        
        urlToCall = ImageRouter.getUploadedCats(limit: String(limit), page: String(page))
        
        if let urlConvertible = urlToCall {
            AlamofireManager
                .shared
                .session
                .request(urlConvertible)
                .validate()
                .responseDecodable(of: [Cats].self) { response in
                    switch response.result {
                        
                    case .success(let result):
                        self.catArray.append(contentsOf: result)
                        self.myCollectionView.reloadData()
                        
                    case .failure(let error):
                        print("MyViewController - requestAPI() error", error.localizedDescription)
                    }
                }
        }
    }
    
    
}

extension MyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == catArray.count {
            print("MyViewController - didSelectItemAt() \(indexPath) Cell")
            //  Upload API
            actionSheetAlert()
        }
    }
    
    func uploadCat() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

extension MyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != catArray.count {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.MY_CAT_CELL, for: indexPath) as? MyCatCollectionViewCell {
                cell.myCatImage.sd_setImage(with: URL(string: catArray[indexPath.row].url))
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.UPLOAD_CELL, for: indexPath) as? UploadCollectionViewCell {
                cell.uploadLabel.text = "업로드 (터치)"
                return cell
            }
        }
        return UICollectionViewCell()
    }
}


//MARK: - PHPickerViewControllerDelegate
extension MyViewController: PHPickerViewControllerDelegate {
    
    // After Finish Picker
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("MyViewController - PHPickerViewController didFinishPicking() called")
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.imageToUpload = image as? UIImage
                    print("타입 \(type(of: self.imageToUpload))")
                    //let imageData = self.imageToUpload?.jpegData(compressionQuality: 1)
        
                    
                    // Multipart로 Encoding
//                    let multipartEncoding: (MultipartFormData) -> Void = {multipartFormData in
//                        multipartFormData.append(imageData!, withName: "file", fileName: "file.jpg", mimeType: "file/jpeg")
//                    }
                    
                    
                    //MARK: Router 이용하는 방법
                    //var urlToCall: URLRequestConvertible?
                    //urlToCall = ImageRouter.postCat

//                    if let urlConvertible = urlToCall {
//                        AF.upload(multipartFormData: { (multipartFormData) in
//                                multipartFormData.append(imageData!, withName: "file", fileName: "file.jpg", mimeType: "file/jpeg") // jpeg 파일로 업로드
//                            }
//                                    , with: urlConvertible)
//                            //.upload(multipartFormData: multipartEncoding, with: urlConvertible)
//                            //.request(urlConvertible)
//                            //.validate()
//                            .uploadProgress(queue: .main, closure: { progress in
//                                print("Upload Progress: \(progress.fractionCompleted)")
//                            })
//                            .responseData { response in
//                                debugPrint(response)
//                            }
//                    }
                    
//                    AlamofireManager.shared.session.upload(multipartFormData: multipartEncoding, with: urlToCall!).responseData{ response in
//                        debugPrint(response)
//                    }
                    
                    //MARK: POST API CALL 성공
                    
                    let url = "https://api.thecatapi.com/v1/images/upload"
                    let header: HTTPHeaders = [
                        "Content-Type" : "multipart/form-data",
                        "x-api-key" : "live_ZocdxQNk5Nx7oA2glGrN2LxJoj9e4sD959ePwTrkmMqxQVrEap0nh5E7t6FPquHh"
                    ]

                    let imageData = self.imageToUpload?.jpegData(compressionQuality: 1)
                    AF.upload(multipartFormData: { (multipartFormData) in
                        multipartFormData.append(imageData!, withName: "file", fileName: "catImage.jpg", mimeType: "image/jpeg") // jpeg 파일로 업로드
                    }
                              ,to: url
                              ,method: .post
                              ,headers: header
                            )
                    .uploadProgress(queue:.main, closure: { progress in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    }).responseString{ response in
                        debugPrint(response)
                        DispatchQueue.main.async {
                            self.myCollectionView.reloadData()
                        }
                    }
                }
            }
        } else {
            print("이미지 없음")
        }
        
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension MyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func actionSheetAlert() {
        let alert = UIAlertController(title: "선택", message: "업로드 방법을 선택하세요", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let camera = UIAlertAction(title: "카메라", style: .default) { [ weak self] (_) in
            self?.presentCamera()
        }
        let album = UIAlertAction(title: "앨범", style: .default) { [ weak self ] (_) in
            //앨범을 선택했을 경우. (위의 PHPicker로 해주자. )
            self?.uploadCat()
        }
        
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true // Editing = true로 해줬지만 원본 이미지만 들어감.
        vc.cameraFlashMode = .off // flash off
        
        
        present(vc, animated: true, completion: nil)
    }
    
    //  image Picker에서 취소 버튼을 눌렀을 때 호출
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            
            //MARK: Upload Image with Camera
            let url = "https://api.thecatapi.com/v1/images/upload"
            let header: HTTPHeaders = [
                "Content-Type" : "multipart/form-data",
                "x-api-key" : "live_ZocdxQNk5Nx7oA2glGrN2LxJoj9e4sD959ePwTrkmMqxQVrEap0nh5E7t6FPquHh"
            ]

            let imageData = image.jpegData(compressionQuality: 1)
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData!, withName: "file", fileName: "catImage.jpg", mimeType: "image/jpeg") // jpeg 파일로 업로드
            }
                      ,to: url
                      ,method: .post
                      ,headers: header
                    )
            .uploadProgress(queue:.main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }).responseString{ response in
                debugPrint(response)
            }
        }
        myCollectionView.reloadData() // 업로드 후 collectionView reload
        dismiss(animated: true, completion: nil)
    }

}

//MARK: - CHTCollectionViewDelegateWaterfallLayout
extension MyViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == catArray.count {
            return CGSize(width: 25, height: 25)
        } else {
            //  업로드 셀
            let width = catArray[indexPath.row].width ?? 100
            let height = catArray[indexPath.row].height ?? 100
            
            return CGSize(width: width, height: height + 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
    
    
}

