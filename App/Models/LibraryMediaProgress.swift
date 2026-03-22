import Foundation

struct LibraryMediaProgress {
    let current: Int?
    let total: Int?
    let secondaryCurrent: Int?
    let secondaryTotal: Int?
}

extension LibraryMediaProgress {
    var currentValue: Int {
        current ?? 0
    }
    
    var totalValue: Int {
        total ?? 0
    }
    
    var secondaryCurrentValue: Int {
        secondaryCurrent ?? 0
    }
    
    var secondaryTotalValue: Int {
        secondaryTotal ?? 0
    }
}
