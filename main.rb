#!/usr/bin/ruby -w
require 'json'
require_relative 'fslfam.rb'
require_relative 'fslmem.rb'
require_relative 'fslmemserializer.rb'

#------------------------------------------------------------Methods------------------------------------------------------------#

def createFamily()
    puts("Please enter the name of the FSL Family...")
    name = gets.chomp
    puts("Please enter any notes you would like associated with this family...")
    notes = gets.chomp
    puts("You will now be directed to create the known head of this family...")
    head = createMember()
    return FSLFam.new(name, head, notes)
end

def createMember()
    puts("Please enter the name of the member...")
    name = gets.chomp
    puts("Please enter the ID number associated with the member...")
    id = gets.chomp
    puts("Please enter this member's initiation class (ie. Fall 2020)...")
    initiationClass = gets.chomp
    puts("Please enter any notes that should be associated with this member (just click enter if this does not apply)...")
    notes = gets.chomp
    return FSLMem.new(id, name, initiationClass, nil, notes)
end

def saveFamily(family)
    if (File.file?("#{family.getName()}.json"))
        puts("This file already exists. Are you sure you want to overwrite it?")
        puts("y - Overwrite pre-existing file")
        puts("n - Cancel Save")
        input = gets.chomp
    end
    if (not input.eq('n'))
        members = FSLFam.compileMemList(family.getHead(), Array.new)
        serializer = FSLMemSerializer.new(members, is_collection: true)
        File.open("#{family.getName()}.json", 'w') do |f|
            f.write(serializer.to_json())
        end
    end
end

#------------------------------------------------------------Main Program------------------------------------------------------------#

puts("Welcome to the Fraternity/Sorority Family Tree Builder")

input = ""
family = nil
selectedMember = nil
while(not input.eql?("q"))
    if(family.nil?)
        puts("Please open or create a family before proceeding...")
        puts("n - Create a new FSLFam")
        puts("o - Open JSON FSLFam data file")
        puts("q - Quit the program")
    elsif(selectedMember.nil?)
        puts("Please select a member before proceeding...")
        puts("1 - Search up and select member by name")
        puts("2 - Search up and select member by ID")
        puts("n - Create a new FSLFam")
        puts("o - Open JSON FSLFam data file")
        puts("s - Save JSON FSFam data file")
        puts("q - Quit the program")
    else #Runs only if family is created/imported and if FSLMem is selected
        puts("Please enter the key on the left to select an option from below:")
        puts("1 - Search up and select member by name")
        puts("2 - Search up and select member by ID")
        puts("3 - Show member profile")
        puts("4 - Add member")
        puts("5 - Edit member")

        puts("n - Create a new FSLFam")
        puts("o - Open JSON FSLFam data file")
        puts("s - Save JSON FSFam data file")
        puts("q - Quit the program")
    end

    input = gets.chomp #Get input from user
    system "clear" #Clears terminal

    case input
    when '1' #Search up and select member by name
        puts("Please enter the name you would like to seach for...")
        query = family.searchByName(gets.chomp)
        while(query.nil?)
            puts("Sorry, but there was no one found by that name. Please try again...")
            query = family.searchByName(gets.chomp)
        end
        selectedMember = query
        puts("#{selectedMember.getName} has been successfully found and is now selected")
    when '2' #Search up and select member by ID
        puts("Please enter the ID you would like to seach for...")
        query = family.searchByID(gets.chomp)
        while(query.nil?)
            puts("Sorry, but there was no one found by that ID. Please try again...")
            query = family.searchByID(gets.chomp)
        end
        selectedMember = query
        puts("#{selectedMember.getName} has been successfully found and is now selected")
    when '3' #Show member profile
        puts("Name: #{selectedBrother.getName()}")
        puts("Member ID: #{selectedBrother.getID()}")
        puts("Initiation Class: #{selectedBrother.getInitationClass()}")
        if(not selectedBrother.getBig().nil?)
            puts("Big: #{selectedBrother.getBig().getName()}")
        end
        if(not selectedBrother.getLittles().empty?)
            selectedBrother.getLittles().each { |little| puts("Little: #{little.getName()}")}
        end
    when '4' #Add member
        member = createMember()
        puts("Please enter the name of #{member.getName}'s Big...")
        big = family.searchByName(gets.chomp)
        while(big.nil?)
            puts("Sorry, but there was no one found by that name. Please try again...")
            big = family.searchByName(gets.chomp)
        end
        member.setBig(big)
    when '5' #Edit member (In progress)
        puts("What would you like to edit/change?")
        puts("1 - Change/Edit Name")
        puts("2 - Change/Edit ID Number")
        puts("3 - Change/Edit Inititiation Class")
        puts("4 - Change/Edit Notes")
        puts("5 - Change Big Brother")
        puts("6 - Add Little")
        puts("7 - Remove Little")
        input = gets.chomp
    when 'n' #Create a new FSLFam
        family = createFamily()
    when 'o' #Open JSON FSLFam data file (In progress)
        if (family.nil?)
            puts("There is already an opened family. Would you like to save the current family?")
            puts("y - Save current family: (#{family.getName()})")
            puts("n - Do not save")
            input = gets.chomp
        end
        if (input.eq('y'))
            saveFamily(family)
        end
    when 's' #Save JSON FSFam data file
        saveFamily(family)
    end
end