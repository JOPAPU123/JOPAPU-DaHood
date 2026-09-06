# JOPAPU Da Hood

## GitHub setup

1. Create a **public** GitHub repository.
2. Upload these files to the repository root:
   - `Main.lua`
   - `SystemHandler.lua`
   - `TargetAssistant.lua`
   - `TargetVisuals.lua`
   - `JopapuMenuPreview.lua`
3. In `Main.lua`, replace:

```lua
Owner = "YOUR_GITHUB_USERNAME"
Name = "YOUR_REPOSITORY"
Branch = "main"
```

with the repository owner, repository name, and branch containing the files.

## Run

Execute only `Main.lua`. It loads the other modules from:

```text
https://raw.githubusercontent.com/<Owner>/<Name>/<Branch>/<FileName>
```

The modules load in this order:

1. `SystemHandler.lua`
2. `TargetAssistant.lua`
3. `TargetVisuals.lua`
4. `JopapuMenuPreview.lua`

To avoid hardcoding repository details, set the configuration before loading `Main.lua`:

```lua
getgenv().JOPAPU_REPOSITORY = {
    Owner = "YOUR_GITHUB_USERNAME",
    Name = "YOUR_REPOSITORY",
    Branch = "main",
}
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY/main/Main.lua"))()
```

Use a commit-pinned branch or tag for reproducible loading when publishing releases.
