# Issue Estimate Reminder

This repository contains the code for the GitHub App "Issue Estimate Reminder". The app automatically detects when a new GitHub issue is created and writes a comment to remind the issue creator to provide a time estimate if it’s missing. This functionality helps the team scope and schedule projects more effectively.

## Features

- **Automatic Issue Detection**: Listens for new issue events.
- **Estimate Reminder**: Comments on issues without an estimate in the format "Estimate: X days".

## Setup

### Prerequisites

- Ruby (version 2.5 or later)
- Bundler
- GitHub App installed on your GitHub account
- Private key for your GitHub App
- [smee.io](https://smee.io) for webhook forwarding

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/Addy832/Issue-Estimate-Reminder.git
    cd Issue-Estimate-Reminder
    ```

2. Install dependencies:

    ```bash
    bundle install
    ```

3. Create a `.env` file in the root of the repository:

    ```bash
    touch .env
    ```

4. Add your environment variables to the `.env` file:

    ```makefile
    GITHUB_APP_ID=your_github_app_id
    WEBHOOK_SECRET=your_webhook_secret
    ```

5. Place your private key file in the `config` directory. Ensure the file is named `issue-estimate-reminder.2024-07-12.private-key.pem`.

6. Add `.env` and private key file to `.gitignore`:

    ```sh
    echo ".env" >> .gitignore
    echo "config/issue-estimate-reminder.2024-07-12.private-key.pem" >> .gitignore
    ```

### Running the App

1. Start the Sinatra server:

    ```bash
    ruby app.rb
    ```

2. Set up webhook forwarding using smee.io:

    ```bash
    smee -u https://smee.io/JFmHbyLtWI9q3tP5 -t http://localhost:3000/payload
    ```

### Running Tests

To run tests using RSpec:

```bash
bundle exec rspec
