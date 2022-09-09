import Foundation

enum BTreePage: Int {

    case interiorIndex = 2
    case interiorTable = 5
    case leafIndex = 10
    case leafTable = 13
}

struct PageHeader {

    let pageType: BTreePage
    let firstFreeBlockStart: UInt16
    let numberOfCells: UInt16
    let startOfContentArea: UInt16
    let fragmentedFreeBytes: UInt8

    init(_ stream: [UInt8]) {
        switch stream[0] {
        case 2:
            pageType = .interiorIndex
        case 5:
            pageType = .interiorTable
        case 10:
            pageType = .leafIndex
        case 13:
            pageType = .leafTable
        default:
            fatalError("Invalid page value encountered \(stream[0])")
        }

        firstFreeBlockStart = UInt16(Array(stream[1..<3]))
        numberOfCells = UInt16(Array(stream[3..<5]))
        startOfContentArea = UInt16(Array(stream[5..<7]))
        fragmentedFreeBytes = stream[7]
    }
}
