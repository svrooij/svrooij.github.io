---
title: "Github Actions: Use secret file"
published: true
categories:
  - Development
tags:
  - Github Actions
  - CI
  - Secret
  - PowerShell
card_image: /assets/images/header-development.png
---

[Github Actions](https://github.com/features/actions) are great for automating tests and builds, among other things. If you need a secret (key/token/password), you can add those in the configuration and use them in your workflow.

Sometimes you need a file that is meant to be secret inside your workflow. This post shows you how to securely save this file as a secret and recreate the file during build. We use base64 encoding for a way to convert any file to a string that can be saved in the secrets.

This is all done in powershell core, which is available in all (Windows/Mac/Linux) runners on Github. The code below should work on any platform, but is only tested on a `windows-latest` runner.

<!--more-->

## File to base64 string

```powershell
$file = "secret.txt";
$bytesFromFile = Get-Content $file -Raw -AsByteStream;
$encodedBytes = [System.Convert]::ToBase64String($bytesFromFile);
# Display base 64 string
Write-Output "File: $file converted to base64:";
Write-Output " ";
Write-Output $encodedBytes;
Write-Output " ";
# Compute and show hash of original file
$fileHashInfo = Get-FileHash $file;
Write-Output "Hash: $($fileHashInfo.Hash)";
```

This will display the Base64 representation of `secret.txt` in the current directory. Change filename accordingly. It will also show the Sha256 hash of the file. That can be used to verify the correct file is loaded.

The long string should be added to the secrets of the repository (or other level), the next code expects the secret name `B64_SECRET1`.

## Write base64 secret to file.

In your Github Action you can Write the secret stored in `B64_SECRET1` to any location, for the sample we will save it to `secret-file.txt` in the defined temp folder `$env:RUNNER_TEMP`. 

{% raw %}
```yaml
name: Some Github Action

jobs:
  build:
    name: Build with secret
    runs-on: windows-latest # Code should run on any platform, change accordingly
    steps:
      - name: Create secret-file.txt from B64_SECRET1
        id: secret-file1
        run: |
          $secretFile = Join-Path -Path $env:RUNNER_TEMP -ChildPath "secret-file.txt"; 
          $encodedBytes = [System.Convert]::FromBase64String($env:SECRET_DATA1); 
          Set-Content $secretFile -Value $encodedBytes -AsByteStream;
          $secretFileHash = Get-FileHash $secretFile;
          Write-Output "::set-output name=SECRET_FILE::$secretFile";
          Write-Output "::set-output name=SECRET_FILE_HASH::$($secretFileHash.Hash)";
          Write-Output "Secret file $secretFile has hash $($secretFileHash.Hash)";
        shell: pwsh
        env:
          SECRET_DATA1: ${{ secrets.B64_SECRET1 }}
```
{%endraw%}

This step has an `id` set to `secret-file1` and will set two outputs namely `SECRET_FILE` and `SECRET_FILE_HASH`. Which can be access in steps after this step. `{% raw %}${{ steps.secret-file1.outputs.SECRET_FILE }}{% endraw %}`. I recommend to always set this value to an environment variable and using the environment variable in the script. This is really reliable and can be tested on your local machine.

## Delete secret file

After each run the runner should be destroyed, so this step is optional. Personally I'm rather save then sorry. So I always add a step to make sure the file is actually removed. This uses the output set by the first step.

{% raw %}
```yaml
      - name: Delete secret file
        run: |
          Remove-Item -Path $env:SECRET_FILE;
        shell: pwsh
        if: always()
        env:
          SECRET_FILE: ${{ steps.secret-file1.outputs.SECRET_FILE }}
```
{% endraw %}

The output `SECRET_FILE` from the step with id `secret-file1` is set as an environment variable `SECRET_FILE` which is then used in the `Remove-Item` command. It is also configured to run always, that means even if some step is unsuccessful the secret file will still be removed.

## Validate hash

You can also add this part to the script that creates the secret file, if you want it to stop the run if the hash doesn't match.

```powershell
$expectedHash = "E2F9.....B6D667247"; # Set to output when generating the Base64 string (and hash)
if ($secretFileHash.Hash -ne $expectedHash) { Write-Output "::error file=$($secretFile)::Hash doesn't match"; Write-Output "Hash doesn't match"; exit 10; }
```

## Conditionally run step

Instead of exiting with an error, like with the code above, you can also conditionally run some step based on the fact if the hash has a specific value.

Just add the correct if condition `if: {%raw%}${{ steps.secret-file1.outputs.SECRET_FILE_HASH == 'E2F9.....B6D667247' }}{%endraw%}` to always run if the hash matches. Or `{%raw%}if: ${{ success() and steps.secret-file1.outputs.SECRET_FILE_HASH == 'E2F9.....B6D667247' }}{%endraw%}` to only run if the hash matches and all previous steps are successful.
