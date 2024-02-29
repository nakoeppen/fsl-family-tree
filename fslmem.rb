class FSLMem

    def initialize(memID, memName, memInitationClass, memBig, memNotes) #This constructor may be phased out
        @id = memID
        @name = memName
        @initiationClass = memInitationClass
        @notes = memNotes

        @big = memBig #Uses FSLMem objects
        @littles = Array.new #Contains FSLMem objects

        #Adds the new little to big's little array
        if (not memBig.nil?)
            memBig.getLittles().append(self)
        end
    end

    def getID
        @id
    end

    def getName
        @name
    end

    def getInitationClass
        @initiationClass
    end

    def getBig
        @big
    end

    def getLittles
        @littles
    end

    def getNotes
        @notes
    end

    def setID=(newID)
        @id = newID
    end

    def setName=(newName)
        @name = newName
    end

    def setInitationClass=(newInitiationClass)
        @initiationClass = newInitiationClass
    end

    def setNotes=(newNotes)
        @notes = newNotes
    end

    def setBig=(newBig)
        @big = newBig
        if (not newBig.nil? and not newBig.getLittles().include?(self))
            newBig.getLittles().append(self)
        end
    end

    def removeLittle(little)
        little.setBig=(nil)
        @littles.delete(little)
    end
end