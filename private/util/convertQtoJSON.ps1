# Convert-HPQuiz.ps1
$inputFile = "questions.csv"
$outputFile = "questions.json"

# Create MD5 hasher
$md5 = [System.Security.Cryptography.MD5]::Create()

# Import CSV data
$csvData = Import-Csv -Path $inputFile

$questions = @()

foreach ($item in $csvData) {
    $question = $item.question.Trim()
    $answer = $item.answer.Trim()
    $difficulty = $item.difficulty.Trim()
    $httpsource = $item.httpsource.Trim()

    # Generate hash from question text
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($question)
    $hashBytes = $md5.ComputeHash($bytes)
    $questionId = [System.BitConverter]::ToString($hashBytes).Replace("-", "").ToLower()

    # Create question object
    $questions += [PSCustomObject]@{
        question   = $question
        answer     = $answer
        id         = $questionId
        difficulty = $difficulty
        httpsource = $httpsource
    }
}

# Convert to JSON
$json = $questions | ConvertTo-Json -Depth 3

# Save to file
$json | Out-File $outputFile -Encoding UTF8

Write-Host "Successfully converted to $outputFile"
