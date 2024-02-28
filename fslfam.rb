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

    def as_json(options = { })
        {
            "json_class" => self.class.name,
            "data" => { "elements" => self.to_a }
        }
    end

    def to_json(*a)
        as_json.to_json(*a)
    end

    #Static Method
    #def self.json_create(o)
    #    new o["data"]["elements"]
    #end

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