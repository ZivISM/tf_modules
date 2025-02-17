#!/bin/bash

# Get connection details from SSM Parameter Store
ENDPOINT=$(aws ssm get-parameter --name "/sftp/endpoint" --query "Parameter.Value" --output text)
USERS=$(aws ssm get-parameter --name "/sftp/users" --query "Parameter.Value" --output text)
SSH_KEY=${SSH_KEY_PATH:-"~/.ssh/sftp_key"}

# Check if username was provided
if [ -z "$1" ]; then
    echo "Please provide username as argument"
    echo "Usage: ./sftp-connect.sh <username>"
    echo "Environment variables:"
    echo "  SSH_KEY_PATH: Path to SSH key (current: $SSH_KEY)"
    echo "Available users:"
    echo "$USERS" | jq -r '.[]'
    exit 1
fi

USERNAME=$1

# Connect to SFTP
echo "Connecting to SFTP server..."
echo "Username: $USERNAME"
echo "Endpoint: $ENDPOINT"
sftp -i "$SSH_KEY" "${USERNAME}@${ENDPOINT}"