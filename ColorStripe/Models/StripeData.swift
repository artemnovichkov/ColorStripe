//
//  Created by Artem Novichkov on 31.05.2021.
//

import Foundation
import CoreGraphics

/// Based on [protocol](https://github.com/madhead/saberlight/blob/master/protocols/Triones/protocol.md).
struct StripeData {

    enum StripeDataError: Error {
        case noColorComponents
    }

    static func powerData(isOn: Bool) -> Data {
        Data([0xCC, isOn ? 0x23 : 0x24, 0x33])
    }

    static func staticColorData(from color: CGColor) throws -> Data {
        guard let components = color.components else {
            throw StripeDataError.noColorComponents
        }
        let red = UInt8(components[0] * 255)
        let green = UInt8(components[1] * 255)
        let blue = UInt8(components[2] * 255)
        return Data([0x56, red, green, blue, 0x00, 0xF0, 0xAA])
    }

    static func modeData(with mode: Mode, speed: Float) -> Data {
        Data([0xBB, mode.rawValue, UInt8((1 - speed) * 255), 0x44])
    }

    static func state(from data: Data?) -> StripeState {
        let state = StripeState()
        guard let data = data else {
            return state
        }
        let values = [UInt8](data)
        state.isOn = values[2] == 0x23
        state.color = CGColor(red: CGFloat(values[6]),
                              green: CGFloat(values[7]),
                              blue: CGFloat(values[8]),
                              alpha: 1)
        if let mode = Mode(rawValue: values[3]) {
            state.mode = mode
        }
        state.speed = Float(values[5])
        return state
    }
}

extension StripeData {

    enum Mode: UInt8, CaseIterable {

        case pulsatingRainbow = 0x25
        case pulsatingRed = 0x26
        case pulsatingGreen = 0x27
        case pulsatingBlue = 0x28
        case pulsatingYellow = 0x29
        case pulsatingCyan = 0x2A
        case pulsatingPurple = 0x2B
        case pulsatingWhite = 0x2C
        case pulsatingRedGreen = 0x2D
        case pulsatingRedBlue = 0x2E
        case pulsatingGreenBlue = 0x2F
        case rainbowStrobe = 0x30
        case redStrobe = 0x31
        case greenStrobe = 0x32
        case blueStrobe = 0x33
        case yellowStrobe = 0x34
        case cyanStrobe = 0x35
        case purpleStrobe = 0x36
        case whiteStrobe = 0x37
        case rainbowJumpingChange = 0x38

        var title: String {
            switch self {
            case .pulsatingRainbow:
                return "Pulsating rainbow"
            case .pulsatingRed:
                return "Pulsating red"
            case .pulsatingGreen:
                return "Pulsating green"
            case .pulsatingBlue:
                return "Pulsating blue"
            case .pulsatingYellow:
                return "Pulsating yellow"
            case .pulsatingCyan:
                return "Pulsating cyan"
            case .pulsatingPurple:
                return "Pulsating purple"
            case .pulsatingWhite:
                return "Pulsating white"
            case .pulsatingRedGreen:
                return "Pulsating red/green"
            case .pulsatingRedBlue:
                return "Pulsating red/blue"
            case .pulsatingGreenBlue:
                return "Pulsating green/blue"
            case .rainbowStrobe:
                return "Rainbow strobe"
            case .redStrobe:
                return "Reds strobe"
            case .greenStrobe:
                return "Green strobe"
            case .blueStrobe:
                return "Blue strobe"
            case .yellowStrobe:
                return "Yellow strobe"
            case .cyanStrobe:
                return "Cyan strobe"
            case .purpleStrobe:
                return "Purple strobe"
            case .whiteStrobe:
                return "White strobe"
            case .rainbowJumpingChange:
                return "Rainbow jumping change"
            }
        }
    }
}
