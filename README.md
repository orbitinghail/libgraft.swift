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

7. **Import and initialize the library** in your Swift files where you want to use it:

   ```swift
   import libgraft
   ```

8. **Start using Graft in your code!**

That's it! The package will be managed automatically by Xcode and Swift Package Manager.
