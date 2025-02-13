# Convert-HPQuiz.ps1
$inputFile = "questions.txt"
$outputFile = "questions.json"

$questions = @()

# Create MD5 hasher
$md5 = [System.Security.Cryptography.MD5]::Create()

Get-Content $inputFile | ForEach-Object {
    if ($_ -match "::") {
        $question, $answer = $_ -split "::", 2

        # Trim whitespace
        $question = $question.Trim()
        $answer = $answer.Trim()

        # Generate hash from question text
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($question)
        $hashBytes = $md5.ComputeHash($bytes)
        $questionId = [System.BitConverter]::ToString($hashBytes).Replace("-", "").ToLower()

        # Create question object
        $questions += [PSCustomObject]@{
            question   = $question
            answer     = $answer
            id         = $questionId
            difficulty = "unmarked"
            httpsource = "#"
        }
    }
} 

# Convert to JSON
$json = $questions | ConvertTo-Json -Depth 3

# Save to file
$json | Out-File $outputFile -Encoding UTF8

Write-Host "Successfully converted to $outputFile"