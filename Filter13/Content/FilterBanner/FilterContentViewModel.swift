//
//  FilterContentViewModel.swift
//  Filter13
//
//  Created by 尾崎拓 on 2022/06/28.
//

import SwiftUI
import Combine
final class FilterContenViewModel :NSObject,  ObservableObject {
    enum Inputs {
        case onAppear
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
        case tapSaveIcon
    }
    

    @Published var image: UIImage?
    @Published var filterdImage: UIImage?
    @Published var isShowActionSheet = false
    @Published var isShowImagePickerView = false
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera
    //フィルターバーナー表示用フラグ
    @Published var isShowBanner = false
    //フィルターを適用するFilterType
    @Published var applyingFilter: FilterType? = nil

    // Combineを実行するためのCancellable
    var cancellables: [Cancellable] = []
    
    var alertTitle: String = ""
    //あらーとを表示するためのフラグ
    
    @Published var isShowAlert = false
    
    override init() {
        super.init()
        //$をつけている（状態変数として使う→今回はPublished → Publisher)
        let imageCancellable = $image.sink { [weak self] uiimage  in
            guard let self = self , let uiimage = uiimage else { return }
            
            self.filterdImage = uiimage
            
        }
        
        let filterCancellable = $applyingFilter.sink { [weak self] filterType in
            guard let self = self,
                  let filterType = filterType,
                  let image = self.image else {
                      return
                  }
            
            //画像加工
            guard let filterdUIImage = self.updateImage(with: image, type: filterType) else {
                return
            }
            self.filterdImage = filterdUIImage
            

            
        }
        cancellables.append(imageCancellable)
        cancellables.append(filterCancellable)
    }
    
    private func updateImage(with image: UIImage, type filter: FilterType) -> UIImage? {
        return filter.filter(inputImage: image)
    }
    

    func apply (_ inputs : Inputs) {
        switch inputs {
        case .onAppear:
            if image == nil {
                isShowActionSheet = true
            }
        case .tappedActionSheet(selectType: let selectType):
            selectedSourceType = selectType
            isShowImagePickerView = true
        case .tapSaveIcon:
            //画像を保存する処理
            UIImageWriteToSavedPhotosAlbum(filterdImage!, self, #selector(imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)

        }
    }
    
    @objc func imageSaveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        alertTitle = error == nil ? "画像が保存されました" : error?.localizedDescription ?? ""
        isShowAlert = true

    }
}
