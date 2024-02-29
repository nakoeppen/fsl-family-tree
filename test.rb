require 'rspec/autorun'
require 'json'
require_relative 'fslfam.rb'
require_relative 'fslmem.rb'

describe FSLMem do
    let(:brother) {FSLMem.new(1140, "Nicholas Koeppen", "Spring 2022", nil, "He is cool")}
    let(:brother2) {FSLMem.new(1145, "Matthew Dembny", "Spring 2023", brother, "He is also cool")}

    it "adds base member" do
        expect(brother.getName()).to eq("Nicholas Koeppen")
    end

    it "associates new littles with their bigs" do
        expect(brother2.getBig()).to eq(brother)
    end

    it "associates bigs with their new littles" do
        expect(brother.getLittles().index(brother2).nil?).to eq(false) #brother2 is in brother's littles
    end

    it "removes big from the little" do
        brother.removeLittle(brother2)
        expect(brother2.getBig()).to eq(nil)
    end

    it "removes littles from the big" do
        brother.removeLittle(brother2)
        expect(brother.getLittles().index(brother2).nil?).to eq(true) #brother2 is not in brother's littles
    end

    it "updates association between littles with their newly added bigs" do
        brother3 = FSLMem.new(1150, "Dmitri Lopez", "Fall 2023", nil, "He three is cool")
        brother3.setBig=(brother2)
        expect(brother2.getLittles().index(brother3).nil?).to eq(false)
    end
end

describe FSLFam do
    let(:brother) {FSLMem.new(1140, "Nicholas Koeppen", "Spring 2022", nil, "He is cool")}
    let(:brother2) {FSLMem.new(1145, "Matthew Dembny", "Spring 2023", brother, "He is also cool")}
    let(:family) {FSLFam.new("Arete", brother, nil)}
    
    it "searches and returns FSLMem by name" do
        expect(family.searchByName(brother2.getName).pop()).to eq(brother2)
    end

    it "searches and returns FSLMem by ID" do
        expect(family.searchByID(brother2.getID)).to eq(brother2)
    end

    it "imports FSLMems from JSON" do
        filename = "./families/test.fslt"
        file = File.read(filename)
        osMems = JSON.parse(file, object_class: OpenStruct)
        family = FSLFam.hashToFSLFam(filename.split('.').first, osMems)
        fslMemIDs = family.compileMemList().map{|mem| mem.getID()}
        hasEveryone = fslMemIDs.include?("1") and fslMemIDs.include?("2") and fslMemIDs.include?("3") and fslMemIDs.include?("4")
        expect(hasEveryone).to eq(true)
    end
end