# Static code analysis scripts to run code analysis and send results to SonarCloud.io
# https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+MSBuild

[CmdletBinding()]
Param(
    [Parameter(Position=1)]
    [switch] $startSonar = $false,
    [switch] $publishSonar = $false,
    # SQ records analysis history, each having its version label
    [string] $version,
    # SonarCloud.io auth, generated in SQ administration
    [string] $authToken
)

if ($startSonar) {
    Write-Host "Starting SonarQube analysis of Git Extensions project (version=$version)... in $pwd"

    SonarScanner.MSBuild begin `
        /key:GitExtensions `
        /name:"Git Extensions" `
        /version:"$version" `
        /d:"sonar.host.url=https://sonarqube.com" `
        /d:"sonar.organization=codeconditioner" `
        /d:"sonar.login=$authToken" `
        /d:"sonar.c.file.suffixes=-" `
        /d:"sonar.cpp.file.suffixes=-" `
        /d:"sonar.objc.file.suffixes=-" `
        /d:"sonar.cs.opencover.reportsPaths=../OpenCover.GitExtensions.xml" `
        /d:"sonar.pullrequest.provider=github" `
        /d:"sonar.pullrequest.github.repository=$env:APPVEYOR_PROJECT_SLUG" `
        /d:"sonar.pullrequest.branch=$env:APPVEYOR_PULL_REQUEST_HEAD_REPO_BRANCH" `
        /d:"sonar.pullrequest.key=$env:APPVEYOR_PULL_REQUEST_NUMBER" `
        /d:"sonar.pullrequest.base=$env:APPVEYOR_REPO_BRANCH"

    Write-Host "SonarQube analysis initialized. Awaiting MSBuild..."
}

if ($publishSonar) {
    Write-Host "Completing SonarQube analysis - publishing results to the server... in $pwd"
    SonarScanner.MSBuild end /d:"sonar.login=$authToken"
    Write-Host "SonarQube analysis completed successfully!"
}