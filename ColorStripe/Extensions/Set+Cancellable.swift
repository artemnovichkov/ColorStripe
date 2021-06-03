//
//  Created by Artem Novichkov on 31.05.2021.
//

import Combine

extension Set where Element: Cancellable {

    func cancel() {
        forEach { $0.cancel() }
    }
}
