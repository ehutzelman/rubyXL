require 'rubyXL/objects/ooxml_object'
require 'rubyXL/objects/container_nodes'

module RubyXL

  # http://www.schemacentral.com/sc/ooxml/e-extended-properties_Properties.html
  class DocumentProperties < OOXMLObject
    attr_accessor :workbook

    define_child_node(RubyXL::StringNode,  :node_name => :Template)
    define_child_node(RubyXL::StringNode,  :node_name => :Manager)
    define_child_node(RubyXL::StringNode,  :node_name => :Company)
    define_child_node(RubyXL::IntegerNode, :node_name => :Pages)
    define_child_node(RubyXL::IntegerNode, :node_name => :Words)
    define_child_node(RubyXL::IntegerNode, :node_name => :Characters)
    define_child_node(RubyXL::StringNode,  :node_name => :PresentationFormat)
    define_child_node(RubyXL::IntegerNode, :node_name => :Lines)
    define_child_node(RubyXL::IntegerNode, :node_name => :Paragraphs)
    define_child_node(RubyXL::IntegerNode, :node_name => :Slides)
    define_child_node(RubyXL::IntegerNode, :node_name => :Notes)
    define_child_node(RubyXL::IntegerNode, :node_name => :TotalTime)
    define_child_node(RubyXL::IntegerNode, :node_name => :HiddenSlides)
    define_child_node(RubyXL::IntegerNode, :node_name => :MMClips)
    define_child_node(RubyXL::BooleanNode, :node_name => :ScaleCrop)
    define_child_node(RubyXL::VectorValue, :node_name => :HeadingPairs)
    define_child_node(RubyXL::VectorValue, :node_name => :TitlesOfParts)
    define_child_node(RubyXL::BooleanNode, :node_name => :LinksUpToDate)
    define_child_node(RubyXL::IntegerNode, :node_name => :CharactersWithSpaces)
    define_child_node(RubyXL::BooleanNode, :node_name => :SharedDoc)
    define_child_node(RubyXL::StringNode,  :node_name => :HyperlinkBase)
    define_child_node(RubyXL::VectorValue, :node_name => :HLinks)
    define_child_node(RubyXL::BooleanNode, :node_name => :HyperlinksChanged)
    define_child_node(RubyXL::StringNode,  :node_name => :DigSig)
    define_child_node(RubyXL::StringNode,  :node_name => :Application)
    define_child_node(RubyXL::StringNode,  :node_name => :AppVersion)
    define_child_node(RubyXL::IntegerNode, :node_name => :DocSecurity)
    set_namespaces('xmlns'    => 'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties',
                   'xmlns:vt' => 'http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes')
    define_element_name 'Properties'

    def add_parts_count(name, count)
      return unless count > 0
      heading_pairs.vt_vector.vt_variant << RubyXL::Variant.new(:vt_lpstr => RubyXL::StringNode.new(:value => name))
      heading_pairs.vt_vector.vt_variant << RubyXL::Variant.new(:vt_i4 => RubyXL::IntegerNode.new(:value => count))
    end
    private :add_parts_count

    def add_part_title(name)
      titles_of_parts.vt_vector.vt_lpstr << RubyXL::StringNode.new(:value => name)
    end
    private :add_parts_count

    def before_write_xml
      if @workbook then
        self.heading_pairs = RubyXL::VectorValue.new(:vt_vector => RubyXL::Vector.new(:base_type => 'variant'))
        add_parts_count('Worksheets', @workbook.worksheets.size)
        add_parts_count('Named Ranges', @workbook.defined_name_container.defined_names.size)

        self.titles_of_parts = RubyXL::VectorValue.new(:vt_vector => RubyXL::Vector.new(:base_type => 'lpstr'))
        @workbook.worksheets.each { |sheet| add_part_title(sheet.sheet_name) }
        @workbook.defined_name_container.defined_names.each { |defined_name| add_part_title(defined_name.name) }



      end

      true
    end
  end


=begin

</HeadingPairs>

<TitlesOfParts>
  <vt:vector size="16" baseType="lpstr">
    <vt:lpstr>Sheet3</vt:lpstr>
    <vt:lpstr>Sheet2</vt:lpstr>
    <vt:lpstr>Fills Test</vt:lpstr>
    <vt:lpstr>Font Test</vt:lpstr>
    <vt:lpstr>Defined Names Test</vt:lpstr>
    <vt:lpstr>Borders Test</vt:lpstr>
    <vt:lpstr>Merged Cells Test</vt:lpstr>
    <vt:lpstr>Charts Test</vt:lpstr>
    <vt:lpstr>Panes&amp;Selections Test</vt:lpstr>
    <vt:lpstr>Sheet1</vt:lpstr>
    <vt:lpstr>Misc tests</vt:lpstr>
    <vt:lpstr>Date Test</vt:lpstr>
    <vt:lpstr>Image Test</vt:lpstr>
    <vt:lpstr>Formula Test</vt:lpstr>

    <vt:lpstr>CoolName1</vt:lpstr>
    <vt:lpstr>NotSoCoolName2</vt:lpstr>
  </vt:vector>
</TitlesOfParts>
=end

end