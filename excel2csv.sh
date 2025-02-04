#!/bin/zsh

# Check if appropriate arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <excel file>"
    exit 1
fi

# Arguments from the terminal
REPO_URL="https://github.com/payakorn/my-script.git" # First argument: URL of the repository
FILE_NAME=$1                                         # Second argument: Name of the Python script

# Extract repository name from REPO_URL
REPO_DIR=$(basename "$REPO_URL" .git)
CURRENT_DIR=$(pwd)

# Check if the repository is already cloned
echo "Checking if $REPO_DIR is cloned..."
if [ -d ~/$REPO_DIR ]; then
    echo "Working in $REPO_DIR. Project already cloned. Pulling latest changes..."
    cd ~/$REPO_DIR || exit
    git pull
    cd -
else
    echo "Project not cloned. Cloning now..."
    # Clone the GitHub repository
    cd ~
    git clone "$REPO_URL"
    cd ~/$REPO_DIR || exit
    cd -
fi

# Install dependencies if a requirements.txt file exists
# Check if the environment exists
if conda env list | grep -w "$REPO_DIR"; then
    echo "Environment '$REPO_DIR' exists."
    conda init
    source ~/.zshrc # For zsh users
    conda activate $REPO_DIR
else
    echo "Environment '$REPO_DIR' does not exist."
    conda env create -f environment.yml
    source ~/.zshrc # For zsh users
    conda init
    conda activate $REPO_DIR
fi

# Extract the directory and base name of the file
FILE_DIR=$(dirname "$FILE_NAME")
FILE_BASE_NAME=$(basename "$FILE_NAME")

# Run the Python script with the full path to the file
python ~/$REPO_DIR/convertExcelToCsv.py "$CURRENT_DIR/$FILE_DIR/$FILE_BASE_NAME"
