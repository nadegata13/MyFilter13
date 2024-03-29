//
//  ImagePicker.swift
//  Filter13
//
//  Created by 尾崎拓 on 2022/07/01.
//

import SwiftUI


//Representable
struct ImagePicker {
    //viewとして使う方
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    var sourceType: UIImagePickerController.SourceType
}

extension  ImagePicker : UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        // UIImagePickerControllerを作る
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        //UIImagePickerControllerはDelegateがある
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

}
//Coordinator
final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // 何を持っていないといけない？ → ImagePicker構造体
    let parent: ImagePicker
    
    init(parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[.originalImage] as? UIImage else { return }
        parent.image = originalImage
        parent.isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.isShown = false
    }
}


