require_relative 'fslmem.rb'

class FSLFam
    def initialize(famName, famHead, famNotes)
        @name = famName
        @head = famHead
        @notes = famNotes
    end

    def getName
        @name
    end

    def getHead
        @head
    end

    def getNotes
        @notes
    end

    def searchByName(memName)
        return compileMemList().select{|mem| mem.getName().eql?(memName)}
    end

    def searchByID(memID)
        return compileMemList().find{|mem| mem.getID().eql?(memID)}
    end

    def findLittles(big)
        return compileMemList().select{|little| little.getBig().eql?(big)}
    end

    def compileMemList()
        @memList = []
        def traverse(node)
            @memList.push(node)
            node.getLittles().each do |little|
                traverse(little)
            end
        end
        traverse(@head)
        return @memList;
    end

    #Static Method
    def self.hashToFSLFam(name, osMems) #osMems is not FSLMem, but rather is an OpenStruct Array
        #Create FSLFam by finding the member with no big
        osHead = osMems.find{|mem| mem.big.nil?}
        head = FSLMem.new(osHead.id, osHead.name, osHead.initationClass, nil, osHead.notes)
        family = FSLFam.new(name, head, nil)
        osMems.delete(osMems.find{|mem| mem.big.nil?})
        #Convert array from OpenStruct to FSLMem
        osMems.map {|member| FSLMem.new(member.id, member.name, member.initationClass, family.searchByID(member.big), member.notes)}
        return family
    end
end