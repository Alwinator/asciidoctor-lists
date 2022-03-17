require 'asciidoctor'
require 'asciidoctor/extensions'
require 'securerandom'

module AsciidoctorLists
  module Asciidoctor

    ListMacroAttributes = Hash.new

  # Replaces list-of::element[] with UUID and saves attributes in ListMacroPlaceholder
  class ListMacro < ::Asciidoctor::Extensions::BlockMacroProcessor
    use_dsl
    named :"list-of"
    name_positional_attributes 'enhanced_rendering'

    def process(parent, target, attrs)
      uuid = SecureRandom.uuid
      ListMacroAttributes[uuid] = {
        element: target,
        enhanced_rendering: attrs['enhanced_rendering']
      }
      create_paragraph parent, uuid, {}
    end
  end
  # Searches for the elements and replaced the UUIDs with the lists
  # Inspired by https://github.com/asciidoctor/asciidoctor-bibtex/blob/master/lib/asciidoctor-bibtex/extensions.rb#L162
  class ListTreeprocessor < ::Asciidoctor::Extensions::Treeprocessor
     def process(document)
       tof_blocks = document.find_by do |b|
         # for fast search (since most searches shall fail)
         (b.content_model == :simple) && (b.lines.size == 1) \
            && (ListMacroAttributes.keys.include?(b.lines[0]))
       end
       tof_blocks.each do |block|
         references_asciidoc = []

         params = ListMacroAttributes[block.lines[0]]
         enhanced_rendering = params[:enhanced_rendering]

         document.find_by(context: params[:element].to_sym).each do |element|

           if element.caption or element.title
             unless element.id
               element.id = SecureRandom.uuid
             end

             if enhanced_rendering
                 if element.caption
                   references_asciidoc << %(xref:#{element.id}[#{element.caption}]#{element.instance_variable_get(:@title)} +)
                 else element.caption
                   references_asciidoc << %(xref:#{element.id}[#{element.instance_variable_get(:@title)}] +)
                 end
               else
                 if element.caption
                  references_asciidoc << %(xref:#{element.id}[#{element.caption}]#{element.title} +)
                 else element.caption
                  references_asciidoc << %(xref:#{element.id}[#{element.title}] +)
               end
             end
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
  block_macro AsciidoctorLists::Asciidoctor::ListMacro
  tree_processor AsciidoctorLists::Asciidoctor::ListTreeprocessor
end
