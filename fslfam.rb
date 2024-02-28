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
        return memList.find{|mem| mem.getName().eql?(memName)}
    end

    def searchByID(memID)
        memList = FSLFam.compileMemList(@head, Array.new)
        return memList.find{|mem| mem.getID().eql?(memID)}
    end

    #Static Method
    def self.compileMemList(head, list)
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