/// SQLite's "schema".
/// - Note: [Link](https://www.sqlite.org/fileformat.html#storage_of_the_sql_database_schema) to type definition.
struct Schema {

    let type: String
    let name: String
    let tableName: String
    let rootPage: UInt
    let sql: String

    init?(_ record: Record) {
        guard // The order and number of columns follows SQL parameters required to create "sqlite_schema" table.
            record.columns.count == 5,
            let type = String(bytes: record.columns[0], encoding: .utf8),
            let name  = String(bytes: record.columns[1], encoding: .utf8),
            let tableName = String(bytes: record.columns[2], encoding: .utf8),
            let sql = String(bytes: record.columns[4], encoding: .utf8),
            record.columns[3].count >= 1
        else {
            return nil
        }
        self.type = type
        self.name = name
        self.tableName = tableName
        self.sql = sql
        rootPage = UInt(record.columns[3])
    }
}
