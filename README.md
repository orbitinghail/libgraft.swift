# libgraft.swift

This repo is a Swift Package Manager (SPM) package to make it easier to use Graft within Swift projects.

## Adding libgraft.swift to Your Xcode Project

Follow these steps to add `libgraft.swift` to your Xcode project using Swift Package Manager:

1. **Open your Xcode project**.

2. **Go to** `File` > `Add Package Dependencies...`

3. **Enter the repository URL** for `libgraft.swift` in the search bar (top right):

   ```
   https://github.com/orbitinghail/libgraft.swift.git
   ```

4. **Select the version** you want to use (usually the latest).

5. **Click "Add Package"**.

6. **Add the libgraft "Package Product" to your application target** on the next screen.

7. **Import and initialize the library** during application startup:

   ```swift
   // first, you need to import libgraft
   import libgraft
   ```

   ```swift
   // then add this to your application startup process
   // this example assumes you are using GRDB for SQLite
   let fm = FileManager.default
   let supportDir = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
   let configPath = supportDir.appendingPathComponent("graft-config.toml")
   let dataPath = supportDir.appendingPathComponent("data")

   // write out a libgraft config file and set the GRAFT_CONFIG env variable
   let config = """
   data_dir = "\(dataPath.path)"
   autosync = false
   make_default = true
   """
   try config.write(to: configPath, atomically: true, encoding: .utf8)
   setenv("GRAFT_CONFIG", configPath.path, 1)

   // Initialize graft
   let tempDB = try DatabaseQueue()
   _ = tempDB.inDatabase { db in libgraft.graft_static_init(db.sqliteConnection) }

   // Open real DB with random Volume ID
   let db = try DatabaseQueue(path: "random")
   ```
