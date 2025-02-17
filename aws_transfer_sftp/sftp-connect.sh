#!/bin/bash

# Get connection details from SSM Parameter Store
ENDPOINT=$(aws ssm get-parameter --name "/sftp/endpoint" --query "Parameter.Value" --output text)
USERS=$(aws ssm get-parameter --name "/sftp/users" --query "Parameter.Value" --output text)
SERVER_ID=$(aws ssm get-parameter --name "/sftp/server-id" --query "Parameter.Value" --output text)
SSH_KEY=${SSH_KEY_PATH:-"~/.ssh/sftp_key"}

# Function to setup SSH keys
setup_ssh_keys() {
    local username=$1
    
    # Check if key already exists
    if [ -f "$SSH_KEY" ]; then
        echo "SSH key already exists at $SSH_KEY"
        read -p "Do you want to generate a new key? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi

    # Generate new SSH key pair
    echo "Generating new SSH key pair..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY"

    # Import public key to AWS Transfer
    echo "Importing public key for user $username..."
    aws transfer import-ssh-public-key \
        --server-id "$SERVER_ID" \
        --user-name "$username" \
        --ssh-public-key-body "$(cat "${SSH_KEY}.pub")"
    
    # Set correct permissions
    chmod 600 "$SSH_KEY"
    chmod 644 "${SSH_KEY}.pub"
}

# Check if username was provided
if [ -z "$1" ]; then
    echo "Please provide username as argument"
    echo "Usage: ./sftp-connect.sh <username> [--setup-keys]"
    echo "Environment variables:"
    echo "  SSH_KEY_PATH: Path to SSH key (current: $SSH_KEY)"
    echo "Available users:"
    echo "$USERS" | jq -r '.[]'
    exit 1
fi

USERNAME=$1

# Check for --setup-keys flag
if [ "$2" = "--setup-keys" ]; then
    setup_ssh_keys "$USERNAME"
fi

# Check if SSH key exists
if [ ! -f "$SSH_KEY" ]; then
    echo "SSH key not found at $SSH_KEY"
    read -p "Do you want to set up SSH keys now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        setup_ssh_keys "$USERNAME"
    else
        echo "Cannot connect without SSH key"
        exit 1
    fi
fi

# Connect to SFTP
echo "Connecting to SFTP server..."
echo "Username: $USERNAME"
echo "Endpoint: $ENDPOINT"
sftp -i "$SSH_KEY" "${USERNAME}@${ENDPOINT}"