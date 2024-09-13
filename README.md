# Cloud Project
This project is a cloud-based Node.js application deployed on Google Cloud Platform (GCP) using Terraform for infrastructure management. The application includes the following features:

## Features:
- *Health Route*: Simple route to check the health status of the application.
- *User Creation Route*: Allows users to create an account, with data stored in a PostgreSQL CloudSQL database.
- *User Verification Route*: Upon signup, users receive an email with a dynamic UUID verification link. The link is processed by a Google Cloud Function and sent through the Mailchimp API. If the link is clicked before expiration, the user's account is successfully verified.

## Infrastructure:
*Google Cloud Platform*: The entire application is hosted on a GCP instance, managed using Terraform.
*CloudSQL*: PostgreSQL database setup via Terraform.
*Google Cloud Pub/Sub*: When a user creates an account, their details are pushed to Pub/Sub, triggering a Cloud Function that sends a verification email.
*Cloud Functions*: Handles user verification emails using the Mailchimp API.
*Load Balancer*: Configured in GCP with SSL for secure traffic, connected to a custom domain (from Namecheap) and auto-scaling Node.js backend.

## Deployment & CI:
*Terraform*: Automates the setup of VPC, security groups, CloudSQL, and the instance hosting the app.
*GitHub Actions*: Configured for Continuous Integration (CI) to automate deployments and testing.

## Setup Instructions:
- Clone the repository
- Install dependencies: npm install
- Configure your GCP credentials and Terraform files.
- Deploy using Terraform: terraform apply
- Set up Mailchimp API and Pub/Sub for user verification.
- Deploy the application to GCP and configure the load balancer with SSL and custom domain.