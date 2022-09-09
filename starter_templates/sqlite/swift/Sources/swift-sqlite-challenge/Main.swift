import Foundation

@main
struct Main {

    static func main() async throws {
        switch CommandLine.argc {
        case 0, 1:
            print("Missing <database path> and <command>")
            return
        case 2:
            print("Missing <command>")
            return
        default:
            break
        }

        let path = CommandLine.arguments[1]
        let command = CommandLine.arguments[2]

        // Read database file as byte array.
        let database = try Data(contentsOf: URL(fileURLWithPath: path))

        // Parse command and perform required actions.
        switch command {
        case ".dbinfo":
            // Parse page header from database.
            let pageHeader = PageHeader(Array(database[100...107]))

            // Obtain all cell pointers.
            let cellPointers = Array(database[108...])
                .prefix(Int(pageHeader.numberOfCells) * 2)
                .chunks(size: 2)
                .map(Array.init)
                .map(UInt16.init)
                .map(Int.init) // Converting `UInt16` to `Int` so we could use these values as array indices.
                               // This is required since Swift uses `Int` as `Array.Index` by default.

            // Parse all schema records.
            let schemas = cellPointers.compactMap { cellPointer -> Schema? in
                let stream = Array(database[cellPointer...])

                let payload = Varint(stream)
                let rowId = Varint(Array(stream[Int(payload.size)...]))

                let record = Record(Array(stream[Int(payload.size + rowId.size)...]))
                return Schema(record)
            }
            print(schemas)

            // You can use print statements as follows for debugging, they'll be visible when running tests.
            print("Logs from your program will appear here!")

            // Uncomment this block to pass the first stage
            // print("number of tables: \(schemas.count)")
        default:
            fatalError("Invalid command \(command)")
        }
    }
}
