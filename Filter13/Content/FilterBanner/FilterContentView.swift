//
//  FilterContentView.swift
//  Filter13
//
//  Created by 尾崎拓 on 2022/06/28.
//

import SwiftUI

struct FilterContentView: View {
    @State private var filterdImage: UIImage?
    @StateObject private var viewModel = FilterContenViewModel()
    var body: some View {
        NavigationView{
            ZStack{
                if let filterdImage = filterdImage {
                    Image(uiImage: filterdImage)
                } else {
                    EmptyView()
                }
                FilterBannerView()

            }
            .navigationTitle("Filter APP")
            .navigationBarItems(trailing: HStack{
                Button {} label: {
                    Image(systemName: "square.and.arrow.down")
                }
                Button{} label: {
                    Image(systemName: "photo")
                }
            })
            .onAppear{
                //画面表示時の処理
                viewModel.apply(.onAppear)
            }
            .actionSheet(isPresented: $viewModel.isShowActionSheet) {
                actionSheet
            }
        }
    }

    var actionSheet : ActionSheet {
        var buttons: [ActionSheet.Button] = []
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = ActionSheet.Button.default(Text("写真を撮る")){
                viewModel.apply(.tappedActionSheet(selectType: .camera))
            }
            buttons.append(cameraButton)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryButton = ActionSheet.Button.default(Text("アルバムから選択")){
                viewModel.apply(.tappedActionSheet(selectType: .photoLibrary))
            }
            buttons.append(photoLibraryButton)
        }
        //キャンセルボタン
        let cancelButton = ActionSheet.Button.cancel(Text("キャンセル"))
        buttons.append(cancelButton)
        let actionSheet = ActionSheet(title: Text("画像選択"), message: nil, buttons: buttons)
        return actionSheet
    }
}

struct FilterContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterContentView()
    }
}
