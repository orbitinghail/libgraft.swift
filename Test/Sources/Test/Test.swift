import Foundation
import Graft
import SQLite3

@main
struct TestApp {
    static func main() {
        do {
            try runTest()
        } catch {
            print("Error: \(error)")
            exit(1)
        }
    }

    static func runTest() throws {
        print("Testing Graft initialization...\n")

        // Create a temporary directory for testing
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("graft-test-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        // Create graft.toml config file
        let configPath = tempDir.appendingPathComponent("graft.toml")
        let dataDir = tempDir.appendingPathComponent("data")

        let config = """
        data_dir = "\(dataDir.path)"
        make_default = true

        [remote]
        type = "memory"
        """
        try config.write(to: configPath, atomically: true, encoding: .utf8)
        setenv("GRAFT_CONFIG", configPath.path, 1)

        print("Config: \(configPath.path)")

        // Initialize Graft
        print("Initializing Graft...")
        try Graft.static_init()
        print("✓ Graft initialized successfully!\n")

        // Open a SQLite connection to test Graft pragmas
        var db: OpaquePointer?
        let dbPath = tempDir.appendingPathComponent("test.db").path
        let openResult = sqlite3_open(dbPath, &db)

        guard openResult == SQLITE_OK, let db = db else {
            throw NSError(domain: "SQLiteError", code: Int(openResult))
        }

        defer {
            sqlite3_close(db)
            try? FileManager.default.removeItem(at: tempDir)
        }

        // Test Graft pragmas
        print("Testing Graft pragmas...")
        print("───────────────────────\n")

        try testPragma(db: db, pragma: "graft_version")
        try testPragma(db: db, pragma: "graft_info")
        try testPragma(db: db, pragma: "graft_status")

        print("───────────────────────")
        print("✓ All tests passed! Graft is fully functional.")
    }

    static func testPragma(db: OpaquePointer, pragma: String) throws {
        let result = try graft_pragma(db: db, pragma: pragma)

        guard !result.isEmpty else {
            print("✗ PRAGMA \(pragma) returned empty result")
            throw NSError(domain: "GraftError", code: 1)
        }

        print("✓ PRAGMA \(pragma)")
        print("  \(result)\n")
    }

    static func graft_pragma(db: OpaquePointer, pragma: String) throws -> String {
        var stmt: OpaquePointer?
        let query = "PRAGMA \(pragma)"
        let prepareResult = sqlite3_prepare_v2(db, query, -1, &stmt, nil)

        guard prepareResult == SQLITE_OK, let stmt = stmt else {
            throw NSError(domain: "SQLiteError", code: Int(prepareResult))
        }

        defer { sqlite3_finalize(stmt) }

        // Expect single row, single column
        guard sqlite3_step(stmt) == SQLITE_ROW else {
            throw NSError(domain: "GraftError", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "PRAGMA \(pragma) returned no rows"
            ])
        }

        guard sqlite3_column_count(stmt) == 1 else {
            throw NSError(domain: "GraftError", code: 3, userInfo: [
                NSLocalizedDescriptionKey: "PRAGMA \(pragma) returned \(sqlite3_column_count(stmt)) columns, expected 1"
            ])
        }

        guard let columnValue = sqlite3_column_text(stmt, 0) else {
            throw NSError(domain: "GraftError", code: 4, userInfo: [
                NSLocalizedDescriptionKey: "PRAGMA \(pragma) returned NULL"
            ])
        }

        let result = String(cString: columnValue)

        // Verify only one row
        guard sqlite3_step(stmt) != SQLITE_ROW else {
            throw NSError(domain: "GraftError", code: 5, userInfo: [
                NSLocalizedDescriptionKey: "PRAGMA \(pragma) returned multiple rows, expected 1"
            ])
        }

        return result
    }
}
