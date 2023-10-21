#!/bin/bash

# Install Homebrew on macOS
if [ "$(uname)" == "Darwin" ]; then
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
    echo "Installing pandoc with Homebrew..."
    brew install pandoc
    brew install librsvg
    brew install python
    brew install basictex
fi

# Install pandoc and additional packages on other Linux distributions
if [ "$(uname)" == "Linux" ]; then
    if ! command -v pandoc &> /dev/null; then
        echo "pandoc is not installed. Installing pandoc..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y pandoc
            sudo apt-get install -y texlive-latex-recommended
            sudo apt-get install -y context
        elif command -v zypper &> /dev/null; then
            sudo zypper addrepo https://download.opensuse.org/repositories/openSUSE:Leap:15.2/standard/openSUSE:Leap:15.2.repo
            sudo zypper refresh
            sudo zypper install pandoc
        else
            echo "pandoc: package manager not found. Please install it manually."
            exit 1
        fi
    fi
fi

# ASCII art
echo "  ______  ____ _  _ ______    ______   ___       ____  ____    ___   "
echo "  | || | ||    \\\ //| || |    | || |  //\\\      || \\\ || \\\  ||     "
echo "    ||   ||==   )X(   ||        ||   ((  ))     ||_// ||  )) ||==      "
echo "    ||   ||___ // \\\  ||        ||    \\_//      ||    ||_//  ||      "
echo "                                                                      "

# prompt for the file to convert
echo -n "Enter the path of the input text file: "
read input_file

# verify if it exists
if [ ! -f "$input_file" ]; then
    echo "Input file not found in the path provided. Please provide a valid path."
    exit 1
fi

# ask for the output name
echo -n "Enter the name of the output PDF file(without extension): "
read output_name

# create output file name
output_file="$output_name.pdf"

echo -n "Converting your file"

# converting using pandoc
(pandoc +RTS -K1000000000 -RTS "$input_file" -o "$output_file" && echo -e "\nFile converted successfully to $output_file") &

dots=""

while ps -p $! &> /dev/null; do
    dots+="."
    echo -ne "\rConverting your file$dots"
    sleep 1
done

echo -e "\r\033[K"

  # verify conversion
if [ $? -eq 0 ]; then
    echo 
else
    echo "Conversion failed. Please check errors and try again."
fi
