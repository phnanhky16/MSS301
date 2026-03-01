# 🚀 Quick Setup Script for Google OAuth2 Login

Write-Host "=================================" -ForegroundColor Cyan
Write-Host "Google OAuth2 Login - Quick Setup" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Get credentials
Write-Host "📋 Step 1: Enter Your Google OAuth Credentials" -ForegroundColor Yellow
Write-Host ""
Write-Host "Please enter your Google Client ID (from Google Cloud Console):"
$clientId = Read-Host "Client ID"

Write-Host ""
Write-Host "Please enter your Google Client Secret:"
$clientSecret = Read-Host "Client Secret" -AsSecureString
$clientSecretPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($clientSecret)
)

Write-Host ""
Write-Host "✅ Credentials received!" -ForegroundColor Green
Write-Host ""

# Step 2: Update docker-compose.yml
Write-Host "📝 Step 2: Updating docker-compose.yml..." -ForegroundColor Yellow

$dockerComposePath = ".\docker\docker-compose.yml"
$content = Get-Content $dockerComposePath -Raw

$content = $content -replace 'GOOGLE_CLIENT_ID: your-google-client-id.apps.googleusercontent.com', "GOOGLE_CLIENT_ID: $clientId"
$content = $content -replace 'GOOGLE_CLIENT_SECRET: your-google-client-secret', "GOOGLE_CLIENT_SECRET: $clientSecretPlain"

Set-Content -Path $dockerComposePath -Value $content

Write-Host "✅ docker-compose.yml updated!" -ForegroundColor Green
Write-Host ""

# Step 3: Update test page
Write-Host "📝 Step 3: Updating test-google-login.html..." -ForegroundColor Yellow

$testPagePath = ".\test-google-login.html"
$testContent = Get-Content $testPagePath -Raw

$testContent = $testContent -replace 'data-client_id="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com"', "data-client_id=`"$clientId`""

Set-Content -Path $testPagePath -Value $testContent

Write-Host "✅ test-google-login.html updated!" -ForegroundColor Green
Write-Host ""

# Step 4: Show next steps
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "✅ Configuration Complete!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Rebuild and restart services:" -ForegroundColor White
Write-Host "   cd docker" -ForegroundColor Gray
Write-Host "   docker-compose down" -ForegroundColor Gray
Write-Host "   docker-compose up -d --build user-service" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Wait 30-60 seconds for services to start" -ForegroundColor White
Write-Host ""
Write-Host "3. Test Google login:" -ForegroundColor White
Write-Host "   - Double-click test-google-login.html" -ForegroundColor Gray
Write-Host "   - Press F12 (open console)" -ForegroundColor Gray
Write-Host "   - Click 'Sign in with Google'" -ForegroundColor Gray
Write-Host "   - Check console for JWT tokens!" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Check logs if needed:" -ForegroundColor White
Write-Host "   docker logs user-service -f" -ForegroundColor Gray
Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "Happy Testing! 🎉" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan

