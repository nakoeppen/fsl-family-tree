require 'jserializer'
require_relative 'fslfam.rb'
require_relative 'fslmem.rb'

class FSLMemSerializer < Jserializer::Base
    root :FSLMem
    attributes :name, :id, :initiationClass, :big

    def name
        "#{object.getName()}"
    end

    def id
        "#{object.getID()}"
    end

    def initiationClass
        "#{object.getInitationClass()}"
    end

    def big
        if (not object.getBig().nil?)
            "#{object.getBig().getName()}"
        end
    end
end