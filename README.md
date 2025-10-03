# L7S Deal Intake System

Complete deal management system with Asana integration and automated project creation.

## 🚀 Features

- 📝 Discovery Form with automated Asana project creation
- 💼 Deal Flow Viewer for tracking active deals
- ✅ Compliance tracking and KYC verification
- 🔗 Automatic task generation with due dates
- ⚡ Real-time updates and notifications
- 🔒 Secure serverless architecture

## 📋 Prerequisites

- Node.js 18 or higher
- Vercel account
- Asana account with:
  - Personal Access Token
  - Workspace ID
  - Team ID

## 🔑 Getting Asana Credentials

### Personal Access Token
1. Visit https://app.asana.com/0/my-apps
2. Click "Create New Token"
3. Name it "L7S Deal Intake"
4. Copy and save securely

### Workspace ID
1. Go to your Asana workspace
2. Check URL: `https://app.asana.com/0/{WORKSPACE_ID}/...`
3. Copy the number after `/0/`

### Team ID
1. Go to your team in Asana
2. Check URL: `https://app.asana.com/0/{WORKSPACE_ID}/{TEAM_ID}`
3. Copy the second long number

## 🚀 Quick Start

### 1. Clone and Install
```bash
git clone https://github.com/YOUR_USERNAME/l7s-deal-intake.git
cd l7s-deal-intake
npm install