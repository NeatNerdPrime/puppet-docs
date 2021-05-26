require 'puppet_references'

module PuppetReferences
  module Puppet
    class Man < PuppetReferences::Reference
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'puppet/man'

      def initialize(*args)
        @latest = '/puppet/latest/man'
        super(*args)
      end

      def build_all
        OUTPUT_DIR.mkpath
        commands = get_subcommands
        puts 'Man pages: Building all...'
        build_index(commands)
        commands.each do |command|
          build_manpage(command)
        end
        puts 'Man pages: Done!'
      end

      def build_index(commands)
        puts 'Man pages: Building index page'
        # Categorize subcommands
        categories = {
            core: %w(
          agent
          apply
          lookup
          master
          module
          resource
        ),
            occasional: %w(
          ca
          certificate
          certificate_request
          certificate_revocation_list
          config
          describe
          device
          doc
          epp
          generate
          help
          node
          parser
          plugin
          script
          ssl
        ),
            weird: %w(
          catalog
          facts
          file
          filebucket
          inspect
          key
          man
          report
          resource_type
          status
        )
        }
        all_in_categories = categories.values.flatten
        # Don't let new commands drop off into The Nothing:
        # leftovers = commands - all_in_categories
        # Clean up any commands that don't exist in this version of Puppet:
        categories.values.each do |list|
          list.reject! {|sub| !commands.include?(sub)}
        end
        header_data = {title: 'Puppet Man Pages',
                       canonical: "#{@latest}/index.html"}
        index_text = <<EOT
#{ make_header(header_data) }

Puppet's command line tools consist of a single `puppet` binary with many subcommands. The following subcommands are available in this version of Puppet:

Core Tools
-----

These subcommands form the core of Puppet's tool set, and every user should understand what they do.

#{ categories[:core].reduce('') {|memo, item| memo << "- [puppet #{item}](#{item}.md)\n"} }

> Note: The `puppet cert` command is available only in Puppet versions prior to 6.0. For 6.0 and later, use the [`puppetserver cert`command](https://puppet.com/docs/puppet/6/puppet_server_ca_cli.html).

Secondary subcommands
-----

Many or most users need to use these subcommands at some point, but they aren't needed for daily use the way the core tools are.

#{ categories[:occasional].reduce('') {|memo, item| memo << "- [puppet #{item}](#{item}.md)\n"} }

Niche subcommands
-----

Most users can ignore these subcommands. They're only useful for certain niche workflows, and most of them are interfaces to Puppet's internal subsystems.

#{ categories[:weird].reduce('') {|memo, item| memo << "- [puppet #{item}](#{item}.md)\n"} }

EOT
        # write index
        filename = OUTPUT_DIR + 'index.md'
        filename.open('w') {|f| f.write(index_text)}
      end

      def get_subcommands
        application_files = Pathname.glob(PuppetReferences::PUPPET_DIR + 'lib/puppet/application/*.rb')
        applications = application_files.map {|f| f.basename('.rb').to_s}
        applications.delete('face_base')
        applications.delete('indirection_base')
        applications.delete('cert')
        applications
      end

      def build_manpage(subcommand)
        puts "Man pages: Building #{subcommand}"
        header_data = {title: "Man Page: puppet #{subcommand}",
                       canonical: "#{@latest}/#{subcommand}.html"}
        # raw_text = PuppetReferences::ManCommand.new(subcommand).get
        man_filepath = "#{PuppetReferences::PUPPET_DIR}" + "/man/man8/puppet-#{subcommand}.8"
        content = make_header(header_data) + PuppetReferences::Util.convert_man(man_filepath)
        filename = OUTPUT_DIR + "#{subcommand}.md"
        filename.open('w') {|f| f.write(content)}
      end
    end
  end
end
