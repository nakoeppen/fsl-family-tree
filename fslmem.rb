class FSLMem
    
    def initialize(memID, memName, memInitationClass, memBig, memNotes) #This constructor may be phased out
        @id = memID
        @name = memName
        @initiationClass = memInitationClass
        @big = memBig #Uses FSLMem objects
        @littles = Array.new #Contains FSLMem objects
        @notes = memNotes

        #Adds the new little to big's little array
        if (not memBig.nil?)
            memBig.addLittle(self)
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
        #newBig.addLittle(self)
    end

    def addLittle(little)
        little.setBig=(self)
        @littles.append(little)
    end

    def removeLittle(little)
        little.setBig=(nil)
        @littles.delete(little)
    end
end