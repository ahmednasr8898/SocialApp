//
//  UIDevice+Extenstion.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/5/20.
//
import Foundation
import UIKit
public extension UIDevice {

    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4_iPhone4s//960
        case iPhone5_iPhone5s_iPhoneSE1stgen//1136
        case iPhone6_iPhone7_iPhone8//1334
        case iPhone11 //1792
        case iPhone7Plus_iPhone8Plus//1920
        case iPhone6Plus //2208
        case iPhone12mini //2340
        case iPhoneX_iPhone11Pro//2436
        case iPhone12_iPhone12Pro//2532
        case iPhone11ProMax //2688
        case iPhone12ProMax //2778
        case Unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_iPhone4s
        case 1136:
            return .iPhone5_iPhone5s_iPhoneSE1stgen
        case 1334:
            return .iPhone6_iPhone7_iPhone8
        case 1792:
            return .iPhone11
        case 1920:
            return .iPhone7Plus_iPhone8Plus
        case 2208:
            return .iPhone6Plus
        case 2340:
            return .iPhone12mini
        case 2436:
            return .iPhoneX_iPhone11Pro
        case 2532:
            return .iPhone12_iPhone12Pro
        case 2688:
            return .iPhone11ProMax
        case 2778:
            return .iPhone12ProMax
        default:
            return .Unknown
        }
    }
}
