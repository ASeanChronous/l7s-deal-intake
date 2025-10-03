// server.js - Backend Express Server for Asana Integration
// Port: 3001 (for local development)
// This file should be deployed to Vercel as serverless functions

const express = require('express');
const cors = require('cors');
const Asana = require('asana');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Asana Client
const client = Asana.Client.create().useAccessToken(process.env.ASANA_ACCESS_TOKEN);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'Server is running',
    timestamp: new Date().toISOString()
  });
});

// Create Deal Project Endpoint
app.post('/api/asana/create-deal-project', async (req, res) => {
  try {
    const { formData } = req.body;
    const applicationId = `DEAL-${Date.now().toString().slice(-6)}`;

    // Validate required environment variables
    if (!process.env.ASANA_ACCESS_TOKEN) {
      throw new Error('ASANA_ACCESS_TOKEN not configured');
    }
    if (!process.env.ASANA_WORKSPACE_ID) {
      throw new Error('ASANA_WORKSPACE_ID not configured');
    }
    if (!process.env.ASANA_TEAM_ID) {
      throw new Error('ASANA_TEAM_ID not configured');
    }

    // Create the project
    const projectData = {
      workspace: process.env.ASANA_WORKSPACE_ID,
      team: process.env.ASANA_TEAM_ID, // Add project to specific team
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
Jurisdiction: ${formData.jurisdiction || 'Not specified'}
Platform Integration: ${formData.platformIntegration}
BATMAN Integration: ${formData.batmanIntegration}
      `.trim()
    };

    console.log('Creating Asana project:', projectData.name);
    const project = await client.projects.createProject(projectData);
    console.log('Project created successfully:', project.gid);

    // Create tasks for the project
    const tasks = [
      {
        name: '📋 Initial Review & Due Diligence',
        notes: `Review application for ${formData.entityName}

Entity Type: ${formData.entityType}
Principal Status: ${formData.principalStatus}
Transaction Type: ${formData.transactionType}

Action Items:
- Review entity documentation
- Verify principal information
- Assess transaction viability
- Complete initial risk assessment`,
        due_on: getDateString(1)
      },
      {
        name: '✅ KYC/AML Verification',
        notes: `Compliance Status: ${formData.complianceStatus}
Risk Level: ${formData.riskLevel}
Jurisdiction: ${formData.jurisdiction || 'Not specified'}
Source of Funds: ${formData.sourceOfFunds || 'Not specified'}

Verification Steps:
- Identity verification
- Address verification
- Enhanced due diligence (if required)
- Sanctions screening
- PEP screening`,
        due_on: getDateString(2)
      },
      {
        name: '📞 Schedule Onboarding Call',
        notes: `Contact: ${formData.email}
Phone: ${formData.phone}
Preferred Channels: ${(formData.commChannels || []).join(', ')}

Discussion Topics:
- Transaction details and timeline
- Compliance requirements
- Platform integration process
- Next steps and milestones`,
        due_on: getDateString(3)
      },
      {
        name: '🔗 Platform Integration Setup',
        notes: `Platform Integration: ${formData.platformIntegration}
BATMAN Integration: ${formData.batmanIntegration}

Target Assets: ${(formData.targetAssets || []).join(', ')}

Setup Tasks:
- Configure platform access
- Set up BATMAN monitoring
- Test integration endpoints
- Verify data synchronization`,
        due_on: getDateString(5)
      },
      {
        name: '📄 Master Stack Agreement Preparation',
        notes: `Transaction Details:
- Mandate Size: ${formData.mandateSize}
- Transaction Stage: ${formData.transactionStage}
- Timeline: ${formData.timeline || 'Not specified'}

Agreement Items:
- Draft master agreement
- Include transaction-specific terms
- Legal review
- Prepare for execution`,
        due_on: getDateString(7)
      },
      {
        name: '💰 Deal Structuring & Terms',
        notes: `Target Assets: ${(formData.targetAssets || []).join(', ')}
Source of Funds: ${formData.sourceOfFunds || 'Not specified'}
Pricing: ${formData.pricing || 'TBD'}

Structuring Tasks:
- Define transaction structure
- Set pricing and terms
- Establish settlement procedures
- Create risk mitigation plan`,
        due_on: getDateString(10)
      },
      {
        name: '✓ Final Review & Approval',
        notes: `Complete all final checks before deal execution:

Final Checklist:
- All compliance checks complete
- Legal agreements signed
- Platform integration tested
- Risk assessment approved
- Management sign-off obtained

Ready for execution once all items verified.`,
        due_on: getDateString(14)
      }
    ];

    // Create each task
    console.log('Creating tasks for project...');
    for (const taskData of tasks) {
      await client.tasks.createTask({
        name: taskData.name,
        notes: taskData.notes,
        due_on: taskData.due_on,
        projects: [project.gid]
      });
      console.log('Task created:', taskData.name);
    }

    // Success response
    res.json({
      success: true,
      applicationId,
      project: {
        gid: project.gid,
        name: project.name,
        url: project.permalink_url
      },
      message: 'Asana project and tasks created successfully'
    });

  } catch (error) {
    console.error('Asana API Error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'Failed to create Asana project',
      error: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }
});

// Helper function to get date string for due dates
function getDateString(daysFromNow) {
  const date = new Date();
  date.setDate(date.getDate() + daysFromNow);
  return date.toISOString().split('T')[0];
}

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found'
  });
});

// Start server (for local development only)
if (process.env.NODE_ENV !== 'production') {
  app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
    console.log(`📝 API endpoint: http://localhost:${PORT}/api/asana/create-deal-project`);
    console.log(`✅ Health check: http://localhost:${PORT}/api/health`);
    console.log('\n📋 Required Environment Variables:');
    console.log('   - ASANA_ACCESS_TOKEN:', process.env.ASANA_ACCESS_TOKEN ? '✓ Set' : '✗ Missing');
    console.log('   - ASANA_WORKSPACE_ID:', process.env.ASANA_WORKSPACE_ID ? '✓ Set' : '✗ Missing');
    console.log('   - ASANA_TEAM_ID:', process.env.ASANA_TEAM_ID ? '✓ Set' : '✗ Missing');
  });
}

// Export for Vercel serverless
module.exports = app;
