# Define a function that recursively searches for Flutter projects and runs `flutter clean`
function Clean-FlutterProjects {
    param (
        [string]$StartPath
    )

    # Check if the starting directory contains a pubspec.yaml file (indicating a Flutter project)
    if (Test-Path "$StartPath\pubspec.yaml") {
        Write-Host "Cleaning Flutter project in: $StartPath"
        Push-Location $StartPath
        flutter clean
        Pop-Location
    }

    # Get all directories recursively from the start path
    $directories = Get-ChildItem -Path $StartPath -Recurse -Directory

    foreach ($directory in $directories) {
        # Check if the directory contains a pubspec.yaml file (indicating a Flutter project)
        if (Test-Path "$($directory.FullName)\pubspec.yaml") {
            Write-Host "Cleaning Flutter project in: $($directory.FullName)"
            # Navigate to the directory and run `flutter clean`
            Push-Location $directory.FullName
            flutter clean
            Pop-Location
        }
    }
}

# Run the function starting from the current directory
Clean-FlutterProjects -StartPath (Get-Location)
