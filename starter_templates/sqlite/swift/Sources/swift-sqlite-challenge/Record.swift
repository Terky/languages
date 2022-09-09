/// SQLite's "Record Format".
/// - Note: [Link](https://www.sqlite.org/fileformat.html#record_format) to format description.
struct Record {

    private(set) var columns: [[UInt8]]

    init(_ stream: [UInt8]) {
        // Parse header size.
        let headerSizeVarint = Varint(stream)
        // Record header size in bytes.
        let headerSize = headerSizeVarint.value
        // Header bytes read.
        var headerOffset = Int(headerSizeVarint.size)
        // Content bytes read + header size.
        var contentOffset = Int(headerSizeVarint.value)

        columns = []

        while headerOffset < headerSize {
            // Parse column serial type.
            let columnInfo = Varint(Array(stream[headerOffset...]))
            let column = Self.parseColumnValue(serialType: Int(columnInfo.value), Array(stream[contentOffset...]))
            
            columns.append(column)

            headerOffset += Int(columnInfo.size)
            contentOffset += column.count
        }
    }

    private static func parseColumnValue(serialType: Int, _ stream: [UInt8]) -> [UInt8] {
        switch serialType {
        case 1: // 8-bit twos-complement integer.
            return Array(stream.prefix(1))
        case let type where isText(serialType: type): // String in the text encoding and (N-13)/2 bytes in length.
            return Array(stream.prefix(getTextLength(serialType: type)))
        default:
            fatalError("Invalid serial type: \(serialType)")
        }
    }

    private static func isText(serialType: Int) -> Bool {
        return serialType >= 13 && !serialType.isMultiple(of: 2)
    }

    private static func getTextLength(serialType: Int) -> Int {
        return (serialType - 13) / 2
    }
}
