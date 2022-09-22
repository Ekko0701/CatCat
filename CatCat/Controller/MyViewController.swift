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
    
    var page = 0
    var limit = 10
    
    var catArray = [Cats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyViewController - viewDidLoad()")
        setUpCollectionView()
        requestUploadedCat(page: page, limit: limit)
    }
    
    func setUpCollectionView() {
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
            uploadCat()
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
                cell.uploadLabel.text = "업로드 GO"
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
                    var urlToCall: URLRequestConvertible?
                    urlToCall = ImageRouter.postCat

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
                    }
                }
            }
        } else {
            print("엘스")
        }
        
    }
}

extension MyViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == catArray.count {
            return CGSize(width: 100, height: 100 + 200)
        } else {
            //  업로드 셀
            let width = catArray[indexPath.row].width ?? 100
            let height = catArray[indexPath.row].height ?? 100
            
            return CGSize(width: width, height: height + 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
    
    
}

