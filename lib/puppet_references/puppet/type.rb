require 'puppet_references'
require 'json'
require 'erb'
require 'ostruct'

module PuppetReferences
  module Puppet
    class Type < PuppetReferences::Reference
      TYPEDOCS_SCRIPT = PuppetReferences::BASE_DIR + 'lib/puppet_references/quarantine/get_typedocs.rb'
      TEMPLATE_FILE = Pathname.new(File.expand_path(__FILE__)).dirname + 'type_template.erb'
      TEMPLATE = ERB.new(TEMPLATE_FILE.read, nil, '-')
      PREAMBLE_FILE = Pathname.new(File.expand_path(__FILE__)).dirname + 'type_preamble.md'
      PREAMBLE = PREAMBLE_FILE.read

      def initialize(*args)
        @latest = '/puppet/latest'
        @output_dir_unified = PuppetReferences::OUTPUT_DIR + 'puppet'
        @output_dir_individual = PuppetReferences::OUTPUT_DIR + 'puppet/types'
        @base_filename = 'type'
        super(*args)
      end

      def build_all
        @output_dir_unified.mkpath
        @output_dir_individual.mkpath
        puts 'Type ref: Building all...'
        type_json = get_type_json
        type_data = JSON.load(type_json)

        write_json_file(type_json)
        build_index(type_data.keys.sort)
        build_unified_page(type_data)
        type_data.each do |name, data|
          build_page(name, data)
        end
        puts 'Type ref: Done!'
      end

      def build_index(names)
        header_data = {title: 'Resource types overview',
                       canonical: "#{@latest}/types/overview.md"}
        links = names.map {|name|
          "* [#{name}](./#{name}.md)" unless name == 'component' || name == 'whit'
        }
        content = make_header(header_data) + "## List of resource types\n\n" + links.join("\n") + "\n\n" + PREAMBLE
        filename = @output_dir_individual + 'overview.md'
        filename.open('w') {|f| f.write(content)}
      end

      def get_type_json
        puts 'Type ref: Getting JSON data'
        PuppetReferences::PuppetCommand.new("ruby #{TYPEDOCS_SCRIPT}").get
      end

      def build_unified_page(typedocs)
        puts 'Type ref: Building unified page'
        header_data = {title: 'Resource Type Reference (Single-Page)',
                       canonical: "#{@latest}/type.html",
                       toc_levels: 2,
                       toc: 'columns'}

        sorted_type_list = typedocs.keys.sort
        all_type_docs = sorted_type_list.collect{|name|
          text_for_type(name, typedocs[name])
        }.join("\n\n---------\n\n")

        content = make_header(header_data) + "\n\n" + PREAMBLE + all_type_docs + "\n\n"
        filename = @output_dir_unified + "#{@base_filename}.md"
        filename.open('w') {|f| f.write(content)}
      end

      def write_json_file(json)
        puts 'Type ref: Writing JSON as file'
        filename = @output_dir_unified + "#{@base_filename}.json"
        filename.open('w') {|f| f.write(json)}
      end

      def build_page(name, data)
        puts "Type ref: Building #{name}"
        header_data = {title: "Resource Type: #{name}",
                       canonical: "#{@latest}/types/#{name}.html"}
        content = make_header(header_data) + "\n\n" + text_for_type(name, data) + "\n\n"
        filename = @output_dir_individual + "#{name}.md"
        filename.open('w') {|f| f.write(content)}
      end

      def text_for_type(name, this_type)
        sorted_attribute_list = this_type['attributes'].keys.sort {|a,b|
          # Float namevar to top and ensure to second-top
          if this_type['attributes'][a]['namevar']
            -1
          elsif this_type['attributes'][b]['namevar']
            1
          elsif a == 'ensure'
            -1
          elsif b == 'ensure'
            1
          else
            a <=> b
          end
        }

        # template uses: name, this_type, sorted_attribute_list, sorted_feature_list, longest_attribute_name
        template_scope = OpenStruct.new({
          name: name,
          this_type: this_type,
          sorted_attribute_list: sorted_attribute_list,
          sorted_feature_list: this_type['features'].keys.sort,
          longest_attribute_name: sorted_attribute_list.collect{|attr| attr.length}.max
        })
        TEMPLATE.result( template_scope.instance_eval {binding} )
      end

    end
  end
end
