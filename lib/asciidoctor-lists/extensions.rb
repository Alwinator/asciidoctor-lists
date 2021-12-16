require 'asciidoctor'
require 'asciidoctor/extensions'
require 'securerandom'

module AsciidoctorLists
  module Asciidoctor

    MacroPlaceholder = Hash.new

  # Replaces tof::[] with ListOfFiguresMacroPlaceholder
  class ListOfFiguresMacro < ::Asciidoctor::Extensions::BlockMacroProcessor
    use_dsl
    named :element_list
    name_positional_attributes 'element'

    def process(parent, _target, attrs)
      uuid = SecureRandom.uuid
      MacroPlaceholder[uuid] = {element: attrs['element']}
      create_paragraph parent, uuid, {}
    end
  end
  # Searches for the figures and replaced ListOfFiguresMacroPlaceholder with the list of figures
  # Inspired by https://github.com/asciidoctor/asciidoctor-bibtex/blob/master/lib/asciidoctor-bibtex/extensions.rb#L162
  class ListOfFiguresTreeprocessor < ::Asciidoctor::Extensions::Treeprocessor
     def process(document)
       tof_blocks = document.find_by do |b|
         # for fast search (since most searches shall fail)
         (b.content_model == :simple) && (b.lines.size == 1) \
            && (MacroPlaceholder.keys.include?(b.lines[0]))
       end
       tof_blocks.each do |block|
         references_asciidoc = []
         element_name = ":" + MacroPlaceholder[block.lines[0]][:element]
         document.find_by(context: eval(element_name)).each do |element|

           if element.caption
             unless element.id
               element.id = SecureRandom.uuid
             end
             references_asciidoc << %(xref:#{element.id}[#{element.caption}]#{element.title} +)
           end
         end

         block_index = block.parent.blocks.index do |b|
           b == block
         end
         reference_blocks = parse_asciidoc block.parent, references_asciidoc
         reference_blocks.reverse.each do |b|
           block.parent.blocks.insert block_index, b
         end
         block.parent.blocks.delete_at block_index + reference_blocks.size
       end
     end
      # This is an adapted version of Asciidoctor::Extension::parse_content,
      # where resultant blocks are returned as a list instead of attached to
      # the parent.
      def parse_asciidoc(parent, content, attributes = {})
        result = []
        reader = ::Asciidoctor::Reader.new content
        while reader.has_more_lines?
          block = ::Asciidoctor::Parser.next_block reader, parent, attributes
          result << block if block
        end
        result
      end
    end
  end
end

# Register the extensions to asciidoctor
Asciidoctor::Extensions.register do
  block_macro AsciidoctorLists::Asciidoctor::ListOfFiguresMacro
  tree_processor AsciidoctorLists::Asciidoctor::ListOfFiguresTreeprocessor
end
