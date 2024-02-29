# Fraternity and Sorority Family Tree Builder
This project is built using Ruby. It features a command line interface which allows you to construct your fraternity or sorority's family tree. All people are stored as FSL Members (FSLMem), which contains information like their name, FSL ID, initiation class, their big, any littles they may have, and even any notes associated with them.

## Features
- All members are stored as FSLMem, which contains their name, FSL ID, initiation class, big, littles, and any important/related notes.
- All families are stored as FSLFam, which contains the family name, the head of the family, and any important/related notes.
- Stores data in JSON format as .fslt (short for fsltree) file

## In Progress
- Creating TUI to be able to manipulate JSON file data
- Compiling/Visualizing data to HTML (or other easily accessibly file format)

## How to Use
1. Install the required packages by entering the directory in your terminal and typing "bundle"
```
bundle
```
2. Run the program
```
ruby main.rb
```