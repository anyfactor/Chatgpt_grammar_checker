$clipboardContent = Get-Clipboard
$OPENAI_API_KEY = ""
$headers = @{
    "Authorization" = "Bearer $OPENAI_API_KEY"
}

$data = @{
    model = "gpt-3.5-turbo"
    messages = @(
        @{
            role = "user"
            content = "Fix the grammar errors and at the end list out the mistakes made:`n`n \'{0}\'" -f $clipboardContent
        }
    )
}

# Convert the hashtable to JSON
$body = $data | ConvertTo-Json


$response = Invoke-RestMethod "https://api.openai.com/v1/chat/completions" `
    -Method Post `
    -Headers $headers `
    -ContentType "application/json" `
    -Body $body
# $jsonData = $response | ConvertTo-Json
$jsonData = $response.choices[0].message.content

Write-Output $jsonData
Set-Clipboard -Value $jsonData