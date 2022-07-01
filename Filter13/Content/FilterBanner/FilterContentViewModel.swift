//
//  FilterContentViewModel.swift
//  Filter13
//
//  Created by 尾崎拓 on 2022/06/28.
//

import SwiftUI
final class FilterContenViewModel : ObservableObject {
    enum Inputs {
        case onAppear
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
    }
    

    @Published var image: UIImage?
    @Published var isShowActionSheet = false
    @Published var isShowImagePickerView = false
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera

    func apply (_ inputs : Inputs) {
        switch inputs {
        case .onAppear:
            if image == nil {
                isShowActionSheet = true
            }
        case .tappedActionSheet(selectType: let selectType):
            selectedSourceType = selectType
            isShowImagePickerView = true

        }
    }
}
