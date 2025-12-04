import Foundation
import libgraft_ext

/// Swift wrapper for the Graft distributed SQLite extension.
///
/// ## Configuration
///
/// Before calling `static_init()`, you must configure Graft by:
/// 1. Creating a `graft.toml` configuration file
/// 2. Setting the `GRAFT_CONFIG` environment variable to point to it
///
/// Example configuration:
/// ```toml
/// data_dir = "/path/to/data"
/// make_default = true
///
/// [remote]
/// type = "memory"
/// ```
///
/// See https://graft.rs/docs/sqlite/config/ for all configuration options.
///
/// ## Usage
///
/// ```swift
/// import Graft
///
/// // Configure Graft
/// let configPath = "/path/to/graft.toml"
/// setenv("GRAFT_CONFIG", configPath, 1)
///
/// // Initialize Graft (registers with SQLite)
/// try Graft.static_init()
///
/// // Now you can use SQLite with Graft pragmas
/// // See https://graft.rs/docs/sqlite/pragmas/
/// ```
public enum Graft {
    /// Error thrown when Graft initialization fails.
    public struct InitializationError: Error, CustomStringConvertible {
        public let errorCode: Int32

        public var description: String {
            "Graft initialization failed with error code \(errorCode)"
        }
    }

    /// Initializes the statically linked Graft extension.
    ///
    /// This registers Graft directly with statically linked SQLite3 symbols.
    /// You must configure Graft via the `GRAFT_CONFIG` environment variable
    /// before calling this function.
    ///
    /// - Throws: `InitializationError` if initialization fails
    ///
    /// - Note: This function should be called once during application startup,
    ///         before opening any SQLite database connections.
    public static func static_init() throws {
        let result = graft_static_init()
        guard result == 0 else {
            throw InitializationError(errorCode: result)
        }
    }
}
