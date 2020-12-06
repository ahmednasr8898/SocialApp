//
//  UILabel+extenstion.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/5/20.
//
import UIKit
extension UILabel {
    func adjustsFontSizeToFitDevice() {
            switch UIDevice().screenType {
            case .iPhone4_iPhone4s:
                font = font.withSize(font.pointSize - 8)
                break
            case .iPhone5_iPhone5s_iPhoneSE1stgen:
                font = font.withSize(font.pointSize - 7)
                break
            case .iPhone6_iPhone7_iPhone8:
                font = font.withSize(font.pointSize - 4)
                break
            case .iPhone11:
                font = font.withSize(font.pointSize - 2)
                break
            case .iPhone7Plus_iPhone8Plus:
                font = font.withSize(font.pointSize - 5)
                break
            case .iPhone6Plus:
                font = font.withSize(font.pointSize - 3)
                break
            case .iPhone12mini:
                font = font.withSize(font.pointSize - 2)
                break
            case .iPhoneX_iPhone11Pro:
                font = font.withSize(font.pointSize - 2)
                break
            case .iPhone12_iPhone12Pro:
                font = font.withSize(font.pointSize - 1)
                break
            case .iPhone11ProMax:
                font = font.withSize(font.pointSize - 1)
                break
            case .iPhone12ProMax:
                font = font.withSize(font.pointSize)
                break
            default:
                font = font.withSize(font.pointSize)
        }
    }
}
