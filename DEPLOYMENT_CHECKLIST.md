# 🚀 L7S Deal Intake - Complete Deployment Checklist

## Pre-Deployment Preparation

### ✅ Files You Need

Copy these files from your project:

1. **Enhanced Discovery Form v14 - Asana Connected**
   - Save as: `frontend/discovery-form.html`
   - Update API endpoint from `http://localhost:3001` to `/api`

2. **Deal Flow Viewer - Crypto & Asset Swaps**
   - Save as: `frontend/deal-viewer.html`

3. **Landing Page**
   - Save as: `frontend/index.html`

---

## Step 1: Project Setup (5 minutes)

### Option A: Use Quick Setup Script

```bash
# Make script executable
chmod +x QUICK_SETUP.sh

# Run setup
./QUICK_SETUP.sh

# This creates the entire project structure!
```

### Option B: Manual Setup

```bash
# Create project directory
mkdir l7s-deal-intake
cd l7s-deal-intake

# Create structure
mkdir -p frontend api/asana

# Copy files
# - package.json
# - vercel.json
# - .env.example
# - api/asana/create-deal-project.js
```

---

## Step 2: Add Your Frontend Files (10 minutes)

### 2.1 Update Discovery Form API Endpoint

Open your `discovery-form.html` and find this line:
```javascript
const response = await fetch('http://localhost:3001/api/asana/create-deal-project', {
```

Replace with:
```javascript
const response = await fetch('/api/asana/create-deal-project', {
```

### 2.2 Copy Files

```bash
# Copy your HTML files to frontend directory
cp /path/to/discovery-form.html frontend/
cp /path/to/deal-viewer.html frontend/
cp /path/to/index.html frontend/
```

---

## Step 3: Get Asana Credentials (5 minutes)

### 3.1 Personal Access Token

1. Visit: https://app.asana.com/0/my-apps
2. Click **"Create New Token"**
3. Name: `L7S Deal Intake`
4. **Copy the token** (you won't see it again!)

### 3.2 Workspace ID

1. Go to your Asana workspace
2. Look at the URL: `https://app.asana.com/0/1234567890123456/...`
3. Copy the number after `/0/` - that's your workspace ID

### 3.3 Team ID

1. Go to the team where you want projects created
2. Click on the team name in Asana
3. Look at the URL: `https://app.asana.com/0/{WORKSPACE_ID}/{TEAM_ID}`
4. Copy the team ID (the second long number in the URL)

**Tip:** You can also get team IDs via API:
```bash
curl https://app.asana.com/api/1.0/workspaces/{WORKSPACE_ID}/teams \
  -H "Authorization: Bearer {YOUR_TOKEN}"
```

### 3.4 Save Credentials

Create `.env` file:
```bash
ASANA_ACCESS_TOKEN=paste_your_token_here
ASANA_WORKSPACE_ID=paste_your_workspace_id_here
ASANA_TEAM_ID=paste_your_team_id_here
```

---

## Step 4: Install Dependencies (2 minutes)

```bash
# Install npm packages
npm install

# Should install:
# - asana
# - cors
# - dotenv
# - express
```

---

## Step 5: Test Locally (Optional - 5 minutes)

```bash
# Install Vercel CLI
npm install -g vercel

# Run local dev server
vercel dev

# Open browser to http://localhost:3000
# Test the form submission
```

---

## Step 6: Deploy to Vercel (5 minutes)

### 6.1 Login to Vercel

```bash
vercel login
```

Choose your login method (GitHub, GitLab, Bitbucket, or Email)

### 6.2 Deploy

```bash
vercel

# Answer prompts:
# ? Set up and deploy? Yes
# ? Which scope? [Your account]
# ? Link to existing project? No
# ? Project name? l7s-deal-intake
# ? In which directory? ./ (just press Enter)
# ? Override settings? No
```

### 6.3 Note Your URLs

Vercel will give you URLs like:
```
Production: https://l7s-deal-intake.vercel.app
```

---

## Step 7: Configure Environment Variables (3 minutes)

### In Vercel Dashboard:

1. Go to https://vercel.com/dashboard
2. Click your project: `l7s-deal-intake`
3. Go to **Settings** → **Environment Variables**
4. Add three variables:

```
Name: ASANA_ACCESS_TOKEN
Value: [paste your token]
Environment: Production, Preview, Development

Name: ASANA_WORKSPACE_ID
Value: [paste your workspace ID]
Environment: Production, Preview, Development

Name: ASANA_TEAM_ID
Value: [paste your team ID]
Environment: Production, Preview, Development
```

5. Click **Save**

### 7.4 Redeploy

```bash
vercel --prod
```

---

## Step 8: Test Production Deployment (5 minutes)

### 8.1 Visit Your Site

1. Go to: `https://l7s-deal-intake.vercel.app`
2. You should see the landing page

### 8.2 Test Discovery Form

1. Click "Discovery Form"
2. Fill out the form completely
3. Submit the application
4. Verify:
   - ✅ Success message appears
   - ✅ Application ID is shown
   - ✅ Asana project link appears

### 8.3 Check Asana

1. Go to your Asana workspace
2. Navigate to your team
3. Find the newly created project
4. Verify:
   - ✅ Project name is correct
   - ✅ All 7 tasks are created
   - ✅ Due dates are set
   - ✅ Project is in the correct team

### 8.4 Test Deal Viewer

1. Go back and click "Deal Flow Viewer"
2. Verify the deals display correctly

---

## Step 9: Custom Domain (Optional - 10 minutes)

### 9.1 In Vercel Dashboard

1. Go to **Settings** → **Domains**
2. Add domain: `deals.l7s.com`

### 9.2 Configure DNS

Add DNS record with your registrar:

**CNAME Record:**
```
Name: deals
Value: cname.vercel-dns.com
```

**Or A Record:**
```
Name: deals
Value: 76.76.21.21
```

### 9.3 Wait for Propagation

DNS changes take 5-30 minutes. Vercel will auto-provision SSL certificate.

---

## Step 10: Setup GitHub (Optional - 5 minutes)

### For Continuous Deployment:

```bash
# Initialize git
git init
git add .
git commit -m "Initial commit: L7S Deal Intake System"

# Create repo on GitHub
# Then:
git remote add origin https://github.com/YOUR_USERNAME/l7s-deal-intake.git
git branch -M main
git push -u origin main

# Connect to Vercel
# In Vercel Dashboard → Settings → Git
# Connect your GitHub repo
```

Now every push to `main` auto-deploys!

---

## 🎯 Success Criteria

Your deployment is successful when:

- [ ] Landing page loads at your Vercel URL
- [ ] Discovery form is accessible
- [ ] Form submission creates Asana project
- [ ] Project appears in correct team
- [ ] All 7 tasks are created with correct due dates
- [ ] Success message shows project link
- [ ] Deal viewer displays deals correctly
- [ ] No console errors in browser
- [ ] API endpoint responds within 2 seconds

---

## 🐛 Troubleshooting

### Issue: "401 Unauthorized" from Asana

**Solution:**
1. Verify token is correct in Vercel environment variables
2. Check token hasn't expired
3. Ensure token has workspace access
4. Regenerate token if needed

### Issue: "Workspace not found"

**Solution:**
1. Verify workspace ID is correct
2. Check token has access to that workspace
3. Try creating project manually in Asana to test access

### Issue: "Team not found"

**Solution:**
1. Verify team ID is correct using API method
2. Ensure your Asana account is a member of the team
3. Check that team is in the same workspace

### Issue: CORS errors

**Solution:**
Already handled in serverless function. If still occurring:
1. Check API endpoint path is `/api/asana/create-deal-project`
2. Verify serverless function has CORS headers
3. Check browser console for specific error

### Issue: Tasks not creating

**Solution:**
1. Check Asana API rate limits (150/min)
2. View Vercel function logs for errors
3. Verify task creation code in serverless function
4. Test with fewer tasks to isolate issue

### Issue: Form submission hangs

**Solution:**
1. Check Vercel function logs
2. Verify all 3 environment variables are set
3. Test API endpoint directly with Postman
4. Check network tab in browser DevTools

### Issue: Projects in wrong team

**Solution:**
1. Verify ASANA_TEAM_ID is correct
2. Get team ID from Asana URL or API
3. Update environment variable in Vercel
4. Redeploy application

---

## 📊 Monitoring

### View Logs

```bash
# Real-time logs
vercel logs

# Or in Dashboard:
# Project → Deployments → [Click deployment] → Logs
```

### Enable Analytics

In Vercel Dashboard:
1. Go to **Analytics** tab
2. Enable Vercel Analytics
3. View traffic and performance metrics

### Monitor Asana API Usage

1. Check Asana's rate limits (150 requests/minute)
2. Monitor function execution time
3. Set up alerts for failures

---

## 🔄 Making Updates

### Quick Updates:

```bash
# Make changes to files
# Then redeploy:
vercel --prod
```

### With GitHub:

```bash
# Make changes
git add .
git commit -m "Description of changes"
git push

# Vercel auto-deploys!
```

---

## 🎉 You're Done!

Your L7S Deal Intake system is now:

✅ Deployed to Vercel
✅ Integrated with Asana
✅ Using Team ID for proper project placement
✅ Accessible via custom URL
✅ Auto-creating projects and tasks
✅ Ready for production use

---

## 📞 Support Resources

- **Vercel Docs:** https://vercel.com/docs
- **Asana API:** https://developers.asana.com
- **Your Project:** https://l7s-deal-intake.vercel.app

---

## 🔐 Security Notes

- ✅ Environment variables are encrypted
- ✅ API tokens are never exposed to frontend
- ✅ CORS is properly configured
- ✅ HTTPS is enabled by default
- ✅ No sensitive data in client code
- ✅ Team-based access control in Asana

---

## 📋 Quick Reference

**Required Credentials:**
- ASANA_ACCESS_TOKEN (from https://app.asana.com/0/my-apps)
- ASANA_WORKSPACE_ID (from Asana URL after /0/)
- ASANA_TEAM_ID (second number in team URL)

**Deployment Commands:**
```bash
vercel login          # Login to Vercel
vercel                # Deploy to preview
vercel --prod         # Deploy to production
vercel logs           # View logs
```

**URLs:**
- Landing: `https://your-project.vercel.app/`
- Discovery: `https://your-project.vercel.app/discovery`
- Deals: `https://your-project.vercel.app/deals`
- API: `https://your-project.vercel.app/api/asana/create-deal-project`

---

**Total Deployment Time:** ~40 minutes
**Difficulty:** Beginner-friendly
**Maintenance:** Minimal - updates via git push

🚀 **Happy Deploying!**
