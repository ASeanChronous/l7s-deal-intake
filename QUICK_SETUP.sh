#!/bin/bash

# L7S Deal Intake - Quick Setup Script
# This script automates the project setup for Vercel deployment

echo "🚀 L7S Deal Intake - Quick Setup"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js first.${NC}"
    echo "Visit: https://nodejs.org/"
    exit 1
fi

echo -e "${GREEN}✅ Node.js found: $(node --version)${NC}"
echo -e "${GREEN}✅ npm found: $(npm --version)${NC}"
echo ""

# Create project directory
PROJECT_DIR="l7s-deal-intake"
echo -e "${BLUE}📁 Creating project directory: $PROJECT_DIR${NC}"
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# Create directory structure
echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p frontend
mkdir -p api/asana

# Create package.json
echo -e "${BLUE}📄 Creating package.json...${NC}"
cat > package.json << 'EOL'
{
  "name": "l7s-deal-intake",
  "version": "1.0.0",
  "description": "L7S Deal Intake System with Asana Integration",
  "main": "api/asana/create-deal-project.js",
  "scripts": {
    "dev": "vercel dev",
    "deploy": "vercel"
  },
  "dependencies": {
    "asana": "^3.0.7",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "express": "^4.18.2"
  },
  "engines": {
    "node": ">=18"
  },
  "keywords": [
    "l7s",
    "deal-intake",
    "asana",
    "crypto",
    "compliance"
  ],
  "author": "L7S",
  "license": "ISC"
}
EOL

# Create vercel.json
echo -e "${BLUE}📄 Creating vercel.json...${NC}"
cat > vercel.json << 'EOL'
{
  "version": 2,
  "name": "l7s-deal-intake",
  "builds": [
    {
      "src": "frontend/**/*.html",
      "use": "@vercel/static"
    },
    {
      "src": "api/**/*.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/",
      "dest": "/frontend/index.html"
    },
    {
      "src": "/discovery",
      "dest": "/frontend/discovery-form.html"
    },
    {
      "src": "/deals",
      "dest": "/frontend/deal-viewer.html"
    },
    {
      "src": "/api/(.*)",
      "dest": "/api/$1"
    }
  ]
}
EOL

# Create .env.example
echo -e "${BLUE}📄 Creating .env.example...${NC}"
cat > .env.example << 'EOL'
# Asana Configuration
ASANA_ACCESS_TOKEN=your_personal_access_token_here
ASANA_WORKSPACE_ID=your_workspace_id_here
ASANA_TEAM_ID=your_team_id_here

# Environment
NODE_ENV=production
EOL

# Create .gitignore
echo -e "${BLUE}📄 Creating .gitignore...${NC}"
cat > .gitignore << 'EOL'
# Dependencies
node_modules/
package-lock.json

# Environment variables
.env
.env.local
.env.production

# Vercel
.vercel

# OS files
.DS_Store
Thumbs.db
*.swp
*.swo

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
logs/
*.log

# IDE
.vscode/
.idea/
*.sublime-*

# Build outputs
dist/
build/
EOL

# Create README.md
echo -e "${BLUE}📄 Creating README.md...${NC}"
cat > README.md << 'EOL'
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
```

### 2. Set Environment Variables

```bash
cp .env.example .env
# Edit .env with your credentials
```

### 3. Deploy to Vercel

```bash
npm install -g vercel
vercel login
vercel
```

### 4. Configure Vercel Environment Variables

In Vercel Dashboard → Settings → Environment Variables:

- `ASANA_ACCESS_TOKEN`
- `ASANA_WORKSPACE_ID`
- `ASANA_TEAM_ID`

### 5. Redeploy

```bash
vercel --prod
```

## 📁 Project Structure

```
l7s-deal-intake/
├── frontend/
│   ├── index.html          # Landing page
│   ├── discovery-form.html # Asana-connected intake form
│   └── deal-viewer.html    # Deal flow viewer
├── api/
│   └── asana/
│       └── create-deal-project.js  # Serverless function
├── package.json
├── vercel.json
└── .env.example
```

## 🧪 Testing

1. Visit your deployed URL
2. Fill out the discovery form
3. Submit and verify:
   - Success message appears
   - Asana project is created
   - Project appears in correct team
   - All tasks are generated

## 🔧 Local Development

```bash
# Install Vercel CLI
npm install -g vercel

# Run local dev server
vercel dev

# Visit http://localhost:3000
```

## 📖 Documentation

- Complete Deployment Guide
- Deployment Checklist
- Asana Credentials Guide

## 🛠️ Tech Stack

- **Frontend:** HTML, CSS, JavaScript
- **Backend:** Node.js, Express
- **Hosting:** Vercel (Serverless)
- **Integration:** Asana API
- **Deployment:** Vercel CLI / GitHub

## 🐛 Troubleshooting

### Projects not appearing in team
- Verify `ASANA_TEAM_ID` is correct
- Check token has team access
- Ensure team is in the same workspace

### "Unauthorized" errors
- Regenerate Personal Access Token
- Verify all three credentials are set in Vercel
- Check token hasn't expired

### API rate limits
- Asana allows 150 requests/minute
- Implement exponential backoff if needed
- Consider caching for high-traffic scenarios

## 📞 Support

For issues or questions:
- Check documentation
- Review troubleshooting section
- Contact development team

## 📄 License

ISC

## 🎉 Acknowledgments

Built for L7S deal management and compliance tracking.
EOL

# Create serverless function
echo -e "${BLUE}📄 Creating serverless API function...${NC}"
cat > api/asana/create-deal-project.js << 'EOL'
const Asana = require('asana');

module.exports = async (req, res) => {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  // Handle OPTIONS preflight
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  try {
    const { formData } = req.body;
    const applicationId = `DEAL-${Date.now().toString().slice(-6)}`;

    // Initialize Asana client
    const client = Asana.Client.create()
      .useAccessToken(process.env.ASANA_ACCESS_TOKEN);

    // Create project with team assignment
    const projectData = {
      workspace: process.env.ASANA_WORKSPACE_ID,
      team: process.env.ASANA_TEAM_ID,
      name: `${formData.entityName} - Deal Application`,
      notes: `
Application ID: ${applicationId}
Entity: ${formData.entityName}
Type: ${formData.entityType}
Contact: ${formData.email}
Phone: ${formData.phone}
Transaction Type: ${formData.transactionType}
Mandate Size: ${formData.mandateSize}
Transaction Stage: ${formData.transactionStage}
Compliance Status: ${formData.complianceStatus}
Risk Level: ${formData.riskLevel}
      `.trim()
    };

    const project = await client.projects.createProject(projectData);

    // Create tasks
    const tasks = [
      {
        name: '📋 Initial Review & Due Diligence',
        notes: `Entity Type: ${formData.entityType}\nPrincipal Status: ${formData.principalStatus}`,
        due_on: getDateString(1)
      },
      {
        name: '✅ KYC/AML Verification',
        notes: `Compliance: ${formData.complianceStatus}\nRisk: ${formData.riskLevel}`,
        due_on: getDateString(2)
      },
      {
        name: '📞 Schedule Onboarding Call',
        notes: `Contact: ${formData.email}\nPhone: ${formData.phone}`,
        due_on: getDateString(3)
      },
      {
        name: '🔗 Platform Integration Setup',
        notes: `Platform: ${formData.platformIntegration}\nBATMAN: ${formData.batmanIntegration}`,
        due_on: getDateString(5)
      },
      {
        name: '📄 Master Stack Agreement',
        notes: `Mandate Size: ${formData.mandateSize}\nStage: ${formData.transactionStage}`,
        due_on: getDateString(7)
      },
      {
        name: '💰 Deal Structuring & Terms',
        notes: `Target Assets: ${(formData.targetAssets || []).join(', ')}`,
        due_on: getDateString(10)
      },
      {
        name: '✓ Final Review & Approval',
        notes: 'Complete final compliance checks and obtain approval',
        due_on: getDateString(14)
      }
    ];

    for (const taskData of tasks) {
      await client.tasks.createTask({
        name: taskData.name,
        notes: taskData.notes,
        due_on: taskData.due_on,
        projects: [project.gid]
      });
    }

    res.status(200).json({
      success: true,
      applicationId,
      project: {
        gid: project.gid,
        name: project.name,
        url: project.permalink_url
      }
    });

  } catch (error) {
    console.error('Asana API Error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'Failed to create Asana project'
    });
  }
};

function getDateString(daysFromNow) {
  const date = new Date();
  date.setDate(date.getDate() + daysFromNow);
  return date.toISOString().split('T')[0];
}
EOL

# Create placeholder for frontend files
echo -e "${BLUE}📄 Creating placeholder README in frontend/...${NC}"
cat > frontend/README.md << 'EOL'
# Frontend Files

Add your three HTML files here:

1. **index.html** - Landing page
2. **discovery-form.html** - Asana-connected intake form (update API endpoint!)
3. **deal-viewer.html** - Deal flow viewer

## Important: Update API Endpoint

In your `discovery-form.html`, change:
```javascript
fetch('http://localhost:3001/api/asana/create-deal-project', {
```

To:
```javascript
fetch('/api/asana/create-deal-project', {
```
EOL

echo ""
echo -e "${GREEN}✅ Project structure created successfully!${NC}"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo ""
echo "1. Copy your frontend HTML files to the 'frontend' directory:"
echo "   - discovery-form.html (Asana-connected form)"
echo "   - deal-viewer.html (Deal flow viewer)"
echo "   - index.html (Landing page)"
echo ""
echo "2. Update API endpoints in your HTML files:"
echo "   Change: http://localhost:3001/api/asana/create-deal-project"
echo "   To: /api/asana/create-deal-project"
echo ""
echo "3. Install dependencies:"
echo "   cd $PROJECT_DIR"
echo "   npm install"
echo ""
echo "4. Get your Asana credentials:"
echo "   - Token: https://app.asana.com/0/my-apps"
echo "   - Workspace ID: From your Asana URL (after /0/)"
echo "   - Team ID: From your team's Asana URL (second number)"
echo ""
echo "5. Create .env file with your credentials:"
echo "   cp .env.example .env"
echo "   # Then edit .env with your actual credentials"
echo ""
echo "6. Deploy to Vercel:"
echo "   npm install -g vercel"
echo "   vercel login"
echo "   vercel"
echo ""
echo "7. Set environment variables in Vercel Dashboard:"
echo "   - ASANA_ACCESS_TOKEN"
echo "   - ASANA_WORKSPACE_ID"
echo "   - ASANA_TEAM_ID"
echo ""
echo "8. Redeploy:"
echo "   vercel --prod"
echo ""
echo -e "${GREEN}🎉 Setup complete! Project ready for deployment.${NC}"
echo ""
echo -e "${BLUE}📁 Project location: $(pwd)${NC}"
echo ""
