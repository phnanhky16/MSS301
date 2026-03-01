# 🔐 OAuth Consent Screen Configuration Guide

## Overview
Before users can sign in with Google, you MUST configure the OAuth consent screen. This tells Google (and your users) what your application is and what data it will access.

---

## 🚀 Step-by-Step Setup

### Step 1: Access Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Sign in with your Google account
3. Select your project (or create a new one)
   - Click the project dropdown at the top
   - Click "New Project"
   - Name it: **KidFavor** or **MSS301-Project**
   - Click "Create"

---

### Step 2: Configure OAuth Consent Screen ⚠️ REQUIRED

1. **Navigate to OAuth Consent Screen**:
   - Left sidebar → APIs & Services → **OAuth consent screen**
   - Or direct link: https://console.cloud.google.com/apis/credentials/consent

2. **Select User Type**:
   
   **Option A: External** (Recommended for testing)
   - ✅ Anyone with a Google account can use your app
   - ✅ Good for development and testing
   - ⚠️ Needs verification for production
   - Click **"External"** → **"Create"**

   **Option B: Internal** (If you have Google Workspace)
   - ✅ Only users in your organization
   - ✅ No verification needed
   - ⚠️ Requires Google Workspace account

3. **Fill App Information** (Page 1/4):
   ```
   App name: KidFavor
   User support email: your-email@gmail.com
   App logo: (Optional - upload your logo)
   
   App domain (Optional):
   - Application home page: http://localhost:3000
   - Application privacy policy: http://localhost:3000/privacy
   - Application terms of service: http://localhost:3000/terms
   
   Authorized domains: (Leave empty for localhost testing)
   
   Developer contact information:
   - Email addresses: your-email@gmail.com
   ```
   → Click **"Save and Continue"**

4. **Scopes** (Page 2/4):
   
   **For Google OAuth2 login, add these scopes:**
   - Click **"Add or Remove Scopes"**
   - Select:
     * ✅ `.../auth/userinfo.email` - See your email address
     * ✅ `.../auth/userinfo.profile` - See your personal info
     * ✅ `openid` - Authenticate using OpenID Connect
   
   **Or use the default scopes** (automatically includes email & profile)
   
   → Click **"Update"** → **"Save and Continue"**

5. **Test Users** (Page 3/4) - IMPORTANT for External apps:
   
   ⚠️ **Required if User Type = External**
   
   Click **"Add Users"** and add Gmail addresses:
   ```
   your-email@gmail.com
   teammate1@gmail.com
   teammate2@gmail.com
   ```
   
   💡 **Tip**: Add all Gmail accounts you'll use for testing
   
   → Click **"Add"** → **"Save and Continue"**

6. **Summary** (Page 4/4):
   - Review your configuration
   - Click **"Back to Dashboard"**

---

### Step 3: Create OAuth 2.0 Credentials

1. **Navigate to Credentials**:
   - Left sidebar → APIs & Services → **Credentials**
   - Or direct link: https://console.cloud.google.com/apis/credentials

2. **Create Credentials**:
   - Click **"+ Create Credentials"** (top of page)
   - Select **"OAuth client ID"**

3. **Configure Credentials**:
   ```
   Application type: Web application
   
   Name: KidFavor Web Client
   
   Authorized JavaScript origins:
   - http://localhost:3000  (Next.js frontend)
   - http://localhost:8080  (API Gateway)
   - http://127.0.0.1:3000  (Alternative localhost)
   
   Authorized redirect URIs:
   - http://localhost:3000/auth/callback
   - http://localhost:8080/login/oauth2/code/google
   - http://localhost:8080/user-service/login/oauth2/code/google
   ```
   
   💡 **For production**, add your actual domains:
   ```
   Authorized JavaScript origins:
   - https://yourdomain.com
   - https://www.yourdomain.com
   
   Authorized redirect URIs:
   - https://yourdomain.com/auth/callback
   - https://api.yourdomain.com/login/oauth2/code/google
   ```

4. **Save Credentials**:
   - Click **"Create"**
   - ✅ **IMPORTANT**: A popup will show your credentials
   - **Copy Your Client ID**: `123456789-abc123.apps.googleusercontent.com`
   - **Copy Your Client Secret**: `GOCSPX-abc123xyz...`
   - Click **"OK"**

---

### Step 4: Configure Backend (user-service)

Update your `application.yml` or set environment variables:

**Option A: Environment Variables** (Recommended):
```bash
export GOOGLE_CLIENT_ID=123456789-abc123.apps.googleusercontent.com
export GOOGLE_CLIENT_SECRET=GOCSPX-abc123xyz...
```

**Option B: application.yml**:
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: 123456789-abc123.apps.googleusercontent.com
            client-secret: GOCSPX-abc123xyz...
            scope:
              - email
              - profile
```

**Option C: Docker Compose**:
```yaml
services:
  user-service:
    environment:
      - GOOGLE_CLIENT_ID=123456789-abc123.apps.googleusercontent.com
      - GOOGLE_CLIENT_SECRET=GOCSPX-abc123xyz...
```

---

### Step 5: Update Test Page

Edit `test-google-login.html`:

**Find line 71** and replace:
```html
data-client_id="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com"
```

**With your actual Client ID**:
```html
data-client_id="123456789-abc123.apps.googleusercontent.com"
```

---

### Step 6: Test Your Setup

1. **Start services**:
   ```bash
   cd docker
   docker-compose up -d
   ```

2. **Open test page**:
   - Double-click `test-google-login.html`

3. **Try signing in**:
   - Click "Sign in with Google"
   - You should see the Google sign-in page
   - Sign in with a test user email
   - ✅ Success!

---

## 📋 OAuth Consent Screen - Field Reference

| Field | Required | Example | Notes |
|-------|----------|---------|-------|
| **App name** | ✅ Yes | KidFavor | Shows to users during consent |
| **User support email** | ✅ Yes | support@kidfavor.com | Users can contact you |
| **App logo** | ❌ No | (Upload 120x120px) | Shows during consent |
| **App domain** | ❌ No | kidfavor.com | For production apps |
| **Authorized domains** | ❌ No | kidfavor.com | Domains where app is hosted |
| **Developer contact** | ✅ Yes | dev@kidfavor.com | Google contacts you here |
| **Scopes** | ❌ Default | email, profile | What data you access |
| **Test users** | ⚠️ If External | your@gmail.com | Who can test (External only) |

---

## 🎯 Publishing Status

### During Development (Unpublished):
- ✅ App status: "Testing"
- ✅ Only test users can sign in
- ✅ No verification needed
- ✅ No user limits (for testing)
- ⚠️ Users see "unverified app" warning

### For Production (Published):
- 📝 Must submit for verification
- 📝 Google reviews your app
- 📝 Can take 1-6 weeks
- ✅ All users can sign in
- ✅ No "unverified app" warning
- ✅ Higher rate limits

---

## 🔒 Security Best Practices

### DO:
- ✅ Keep Client Secret secure (never commit to Git)
- ✅ Use environment variables for credentials
- ✅ Use HTTPS in production
- ✅ Regularly rotate credentials
- ✅ Limit scopes to what you need

### DON'T:
- ❌ Commit credentials to version control
- ❌ Share Client Secret publicly
- ❌ Request unnecessary scopes
- ❌ Use HTTP in production
- ❌ Share credentials via email/chat

---

## 🐛 Common Issues

### Issue: "Access blocked: This app's request is invalid"
**Cause**: OAuth consent screen not configured
**Fix**: Complete Step 2 above (Configure OAuth Consent Screen)

### Issue: "Sign in with Google temporarily disabled"
**Cause**: No test users added (for External apps)
**Fix**: Add your Gmail to Test Users in OAuth consent screen

### Issue: "redirect_uri_mismatch"
**Cause**: Redirect URI not authorized
**Fix**: 
1. Go to Credentials → Edit OAuth client
2. Add the redirect URI shown in the error
3. Save and try again

### Issue: "invalid_client"
**Cause**: Wrong Client ID or Client Secret
**Fix**: 
1. Verify Client ID in test-google-login.html
2. Verify Client Secret in application.yml
3. Check for typos or extra spaces

### Issue: Users see "unverified app" warning
**Cause**: App not verified by Google (normal during development)
**Fix**: 
- Click "Advanced" → "Go to KidFavor (unsafe)"
- This is normal for testing
- Submit for verification before production

---

## 📊 Verification Status

| User Limit | Status | Verification Needed | Timeline |
|------------|--------|---------------------|----------|
| Test users only | Testing | ❌ No | Immediate |
| < 100 users | Testing | ❌ No | Immediate |
| 100+ users | Production | ✅ Yes | 1-6 weeks |

---

## ✅ Verification Checklist

Before testing:
- [ ] Google Cloud project created
- [ ] OAuth consent screen configured
- [ ] App name set: "KidFavor"
- [ ] User support email added
- [ ] Developer contact email added
- [ ] Scopes configured (email, profile)
- [ ] Test users added (if External)
- [ ] OAuth 2.0 credentials created
- [ ] Client ID copied
- [ ] Client Secret copied
- [ ] Client ID added to test-google-login.html
- [ ] Client ID/Secret added to application.yml
- [ ] Authorized origins added (localhost:3000, localhost:8080)
- [ ] Authorized redirect URIs added

After testing:
- [ ] Users can sign in
- [ ] No error messages
- [ ] JWT tokens generated
- [ ] User info displayed
- [ ] Database records created

---

## 🎓 Next Steps

1. ✅ Complete this OAuth consent screen setup
2. ✅ Get your Client ID and Secret
3. ✅ Configure test-google-login.html
4. ✅ Configure application.yml
5. ✅ Test with test-google-login.html
6. ✅ Integrate into Next.js frontend
7. 📝 Submit for verification (when ready for production)

---

## 📚 Official Documentation

- [Google OAuth 2.0 Setup](https://developers.google.com/identity/protocols/oauth2)
- [OAuth Consent Screen](https://support.google.com/cloud/answer/10311615)
- [OAuth 2.0 Scopes](https://developers.google.com/identity/protocols/oauth2/scopes)
- [Verification Guidelines](https://support.google.com/cloud/answer/9110914)

---

## 🆘 Need Help?

**Check Console Logs:**
```bash
docker logs user-service -f
```

**Test Your Setup:**
```bash
# Check if service is running
curl http://localhost:8081/actuator/health

# Test endpoint exists
curl http://localhost:8081/swagger-ui.html
```

**Verify Credentials:**
- Google Cloud Console → APIs & Services → Credentials
- Check Client ID matches everywhere
- Check redirect URIs are correct

**Questions?** See the other documentation files or check logs!

