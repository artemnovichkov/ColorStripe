//
//  Created by Artem Novichkov on 31.05.2021.
//

import Foundation
import CoreGraphics

final class StripeState: ObservableObject {
    
    @Published var isOn = false
    @Published var color: CGColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
    @Published var mode: StripeData.Mode?
    @Published var speed: Float = 0
}
