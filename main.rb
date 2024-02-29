#!/usr/bin/ruby -w
require 'json'
require_relative 'fslfam.rb'
require_relative 'fslmem.rb'
require_relative 'fslmemserializer.rb'

FILE_EXT = ".fslt"
FAMILIES_DIR = "./families/"

#------------------------------------------------------------Methods------------------------------------------------------------#

def bigNameSearch(name)
    bigs = family.searchByName(name)
    big = nil
    while(bigs.empty?) #While big is not found
        puts("Sorry, but there was no one found by that name. Please try again...")
        bigs = family.searchByName(gets.chomp)
    end
    if (bigs.length() > 1) #If more than one big found under that name
        puts("Sorry, but there were multiple people found under that name. Please specify by ID...")
        bigs.each do |b|
            puts("#{b.getID()} - #{b.getName()} - #{b.getInitationClass()}")
        end
        input = gets.chomp
        big = bigs.find{|mem| mem.getID().eql?(input)}
        while (big.nil?) #While they mistyped ID
            puts("Sorry, you typed the ID wrong. Please try again...")
            bigs.each do |b|
                puts("#{b.getID()} - #{b.getName()} - #{b.getInitationClass()}")
            end
            input = gets.chomp
            big = bigs.find{|mem| mem.getID().eql?(input)}
        end
    else
        big = bigs.pop
    end
    return big;
end

def createFamily()
    puts("Please enter the name of the FSL Family...")
    name = gets.chomp
    puts("Please enter any notes you would like associated with this family...")
    notes = gets.chomp
    puts("Please enter the name of the head member of this family...")
    name = gets.chomp
    puts("Please enter the ID number associated with the head member...")
    id = gets.chomp
    puts("Please enter this head member's initiation class (ie. Fall 2020)...")
    initiationClass = gets.chomp
    puts("Please enter any notes that should be associated with the head member (just click enter if this does not apply)...")
    notes = gets.chomp

    return FSLFam.new(name, FSLMem.new(id, name, initiationClass, nil, notes), notes)
end

def createMember(family)
    puts("Please enter the name of the member...")
    name = gets.chomp
    puts("Please enter the ID number associated with the member...")
    id = gets.chomp
    while(not family.searchByID(id).nil?) #Make sure ID is unique to FSLMem
        puts("That ID has already been created. Please use a different ID...")
        id = gets.chomp
    end
    puts("Please enter the name of this member's Big...")
    bigNameSearch(gets.chomp)
    puts("Please enter this member's initiation class (ie. Fall 2020)...")
    initiationClass = gets.chomp
    puts("Please enter any notes that should be associated with this member (just click enter if this does not apply)...")
    notes = gets.chomp

    return FSLMem.new(id, name, initiationClass, big, notes)
end

def saveFamily(family)
    if (File.file?("#{FAMILIES_DIR}#{family.getName()}#{FILE_EXT}"))
        puts("This file already exists. Are you sure you want to overwrite it?")
        puts("y - Overwrite pre-existing file")
        puts("n - Cancel Save")
        input = gets.chomp
    end
    if (not input.eql?('n'))
        members = FSLFam.compileMemList(family.getHead(), Array.new)
        serializer = FSLMemSerializer.new(members, is_collection: true)
        puts(JSON.pretty_generate(serializer.as_json(root: false)))
        File.open("#{FAMILIES_DIR}#{family.getName()}#{FILE_EXT}", 'w') do |f|
            f.write(JSON.pretty_generate(serializer.as_json(root: false)))
        end
    end
end

def importFamily()
    puts("Please type the name of the FSLFam you would like to import. Your options are listed below.")
    potentialFiles = Dir.glob("*#{FILE_EXT}", base: FAMILIES_DIR)
    potentialFiles.each {|potentialFile| puts("FSLFam File: #{potentialFile}")}
    filename = gets.chomp
    while(not potentialFiles.include?(filename))
        puts("You typed the wrong filename. Your options are listed below.")
        potentialFiles = Dir.glob("#{FAMILIES_DIR}*#{FILE_EXT}")
        potentialFiles.each {|potentialFile| puts("FSLFam File: #{potentialFile}")}
        filename = gets.chomp
    end
    file = File.read("#{FAMILIES_DIR}#{filename}")
    members = JSON.parse(file, object_class: OpenStruct)
    family = FSLFam.hashToFSLFam(filename.split('.').first, members)
    return family
end

#------------------------------------------------------------Main Program------------------------------------------------------------#

puts("Welcome to the Fraternity/Sorority Family Tree Builder")

input = ""
family = nil
selectedMember = nil
unsavedChanges = false
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
        puts("3 - Add member")
        puts("n - Create a new FSLFam")
        puts("o - Open JSON FSLFam data file")
        puts("s - Save JSON FSFam data file")
        puts("q - Quit the program")
    else #Runs only if family is created/imported and if FSLMem is selected
        puts("Please enter the key on the left to select an option from below:")
        puts("1 - Search up and select member by name")
        puts("2 - Search up and select member by ID")
        puts("3 - Add member")
        puts("4 - Show member profile")
        puts("5 - Edit member")

        puts("n - Create a new FSLFam")
        puts("o - Open JSON FSLFam data file")
        puts("s - Save JSON FSLFam data file")
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
        puts("#{selectedMember.getName()} has been successfully found and is now selected")
    when '2' #Search up and select member by ID
        puts("Please enter the ID you would like to seach for...")
        query = family.searchByID(gets.chomp)
        while(query.nil?)
            puts("Sorry, but there was no one found by that ID. Please try again...")
            query = family.searchByID(gets.chomp)
        end
        selectedMember = query
        puts("#{selectedMember.getName()} has been successfully found and is now selected")
    when '3' #Add member
        selectedMember = createMember(family)
        puts("#{selectedMember.getName()} has been successfully created and is now selected")
        unsavedChanges = true
    when '4' #Show member profile
        puts("Name: #{selectedMember.getName()}")
        puts("Member ID: #{selectedMember.getID()}")
        puts("Initiation Class: #{selectedMember.getInitationClass()}")
        if(not selectedMember.getBig().nil?)
            puts("Big: #{selectedMember.getBig().getName()}")
        end
        if(not selectedMember.getLittles().empty?)
            selectedMember.getLittles().each { |little| puts("Little: #{little.getName()}")}
        end
        if(not selectedMember.getNotes().nil?)
            puts("Notes: #{selectedMember.getNotes()}")
        end
    when '5' #Edit member (In progress)
        puts("What would you like to edit/change?")
        puts("1 - Change/Edit Name")
        puts("2 - Change/Edit ID Number")
        puts("3 - Change/Edit Inititiation Class")
        puts("4 - Change/Edit Notes")
        puts("5 - Change Big")
        #puts("6 - Add Little")
        #puts("7 - Remove Little")
        input = gets.chomp
        case input
        when '1' #Name
            puts("Please input the new name for #{selectedMember.getName()}...")
            selectedMember.setName=(gets.chomp)
        when '2' #ID Number
            puts("Please input the new ID for #{selectedMember.getName()}...")
            selectedMember.setID=(gets.chomp)
        when '3' #Initiation Class
            puts("Please input the new initiation class for #{selectedMember.getName()}...")
            selectedMember.setInitationClass=(gets.chomp)
        when '4' #Notes
            puts("Please input the updated notes for #{selectedMember.getName()}...")
            selectedMember.setNotes=(gets.chomp)
        when '5' #Big
            puts("Please input the name of the new big for #{selectedMember.getName()}...")
            selectedMember.setBig=(bigNameSearch(gets.chomp))
        #when '6' #Add Little
        #when '7' #Remove Little
        end
        unsavedChanges = true
    when 'n' #Create a new FSLFam
        family = createFamily()
    when 'o' #Open JSON FSLFam data file (In progress)
        if (unsavedChanges)
            puts("There is already an opened family with unsaved changes. Would you like to save the current family first?")
            puts("y - Save current family: (#{family.getName()})")
            puts("n - Do not save, proceed with import")
            input = gets.chomp
            if (input.eql?('y'))
                saveFamily(family)
            end
        end
        family = importFamily()
        unsavedChanges = false
    when 's' #Save JSON FSLFam data file
        saveFamily(family)
    end
end

if (unsavedChanges)
    puts("You are about to quit with unsaved changes. Would you like to save first?")
    puts("y - Save the (#{family.getName()}) family and quit")
    puts("n - Quit without saving")
    input = gets.chomp
    if (input.eql?('y'))
        saveFamily(family)
    end
end
