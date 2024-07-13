# README

Issue Estimate Reminder

This repository contains the code for the GitHub App "Issue Estimate Reminder". The app automatically detects when a new GitHub issue is created and writes a comment to remind the issue creator to provide a time estimate if it’s missing. This functionality helps the team scope and schedule projects more effectively.

Features

Automatic Issue Detection: Listens for new issue events.
Estimate Reminder: Comments on issues without an estimate in the format "Estimate: X days".
Setup
Prerequisites
Ruby (version 2.5 or later)
Bundler
GitHub App installed on your GitHub account
Private key for your GitHub App
smee.io for webhook forwarding
Installation
Clone the repository:

sh
Copy code
git clone https://github.com/Addy832/Issue-Estimate-Reminder.git
cd Issue-Estimate-Reminder
Install dependencies:

sh
Copy code
bundle install
Create a .env file in the root of the repository:

sh
Copy code
touch .env
Add your environment variables to the .env file:

makefile
Copy code
GITHUB_APP_ID=your_github_app_id
WEBHOOK_SECRET=your_webhook_secret
Place your private key file in the config directory:
Ensure the file is named issue-estimate-reminder.2024-07-12.private-key.pem.

Add .env and private key file to .gitignore:

sh
Copy code
echo ".env" >> .gitignore
echo "config/issue-estimate-reminder.2024-07-12.private-key.pem" >> .gitignore
Running the App
Start the Sinatra server:

sh
Copy code
ruby app.rb
Set up webhook forwarding using smee.io:

sh
Copy code
smee -u https://smee.io/JFmHbyLtWI9q3tP5 -t http://localhost:3000/payload
Testing the App
Create a new issue in the test repository:

Go to the "Issues" tab in your test repository (e.g., test---Issue-Estimate-Reminder).
Click on "New issue".
Provide a title and description for the issue without including the "Estimate: X days" format.
Example:

vbnet
Copy code
Title: Test issue without estimate
Description: This is a test issue created to verify the GitHub app functionality.
Verify the comment:

After creating the issue, the GitHub app should automatically detect the new issue and add a comment reminding you to provide an estimate in the format "Estimate: X days".
Check the issue for the comment added by the GitHub app.
Running RSpec Tests
Run RSpec tests:
sh
Copy code
bundle exec rspec

