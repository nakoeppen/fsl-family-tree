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
        memList = FSLFam.compileMemList(@head, Array.new)
        return memList.select{|mem| mem.getName().eql?(memName)}
    end

    def searchByID(memID)
        memList = FSLFam.compileMemList(@head, Array.new)
        return memList.find{|mem| mem.getID().eql?(memID)}
    end

    def findLittles(big)
        memList = FSLFam.compileMemList(@head, Array.new)
        return memList.select{|little| little.getBig().eql?(big)}
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


    #Static Method
    def self.compileMemList(head, list) #Head is FSLMem
        list.append(head)
        if (head.getLittles().empty?)
            return list
        else
            head.getLittles().each do |little|
                return FSLFam.compileMemList(little, list)
            end
        end
    end
end