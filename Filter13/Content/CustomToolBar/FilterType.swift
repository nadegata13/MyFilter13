//
//  FilterType.swift
//  Filter13
//
//  Created by 尾崎拓 on 2022/07/05.
//

import Foundation
import CoreImage
import UIKit
import CoreImage.CIFilterBuiltins

enum FilterType: String {
    case pixellate = "モザイク"
    case sepiaTone = "セピア"
    case sharpenLuminance = "シャープ"
    case photoEffect = "モノクロ"
    case gaussianBlur = "ブラー"
    
    //自分自身の値によって(enumのcase)フィルターをかける
    private func makeFilter(inputImage: CIImage?) -> CIFilter {
        //自分自身のインスタンスの値はselfで表現できる
        switch self {
        case .pixellate:
            let currentFilter = CIFilter.pixellate()
            currentFilter.inputImage = inputImage
            return currentFilter
        case .sepiaTone:
            let currentFilter = CIFilter.sepiaTone()
            currentFilter.inputImage = inputImage
            //セピアの強さ
            currentFilter.intensity = 1
            return currentFilter
        case .sharpenLuminance:
            let currentFilter = CIFilter.sharpenLuminance()
            currentFilter.inputImage = inputImage
            //エッジの強度
            currentFilter.sharpness = 0.5
            //シャープが適応する範囲
            currentFilter.radius = 100
            return currentFilter
        case .photoEffect:
            let currentFilter = CIFilter.photoEffectMono()
            currentFilter.inputImage = inputImage
            return currentFilter
        case .gaussianBlur:
            let currentFilter = CIFilter.gaussianBlur()
            currentFilter.inputImage = inputImage
            //ボカシの半径
            currentFilter.radius = 10
            return currentFilter
        }

    }
    //UIImageを受け取って加工をしたUIImageを返す
    func filter(inputImage: UIImage) -> UIImage? {
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = makeFilter(inputImage: beginImage)
        
        //フィルター加工されたCIImageを取り出す
        guard let outputImage = currentFilter.outputImage else {
            return nil
        }
        if let cgimage = context.createCGImage(outputImage, from: outputImage.extent){
            //うまく取り出せたら
            //CCImageからUIImageを作成する
            //CCImageは向きが消失しているので、元のUIImageから向き情報を使ってUIImageを作成する
            return UIImage(cgImage: cgimage, scale: 0,
                           orientation: inputImage.imageOrientation)
        } else {
            return nil
        }
        
        return UIImage()
        
    }
}
