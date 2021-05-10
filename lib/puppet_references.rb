require 'pathname'

module PuppetReferences
  BASE_DIR = Pathname.new(File.expand_path(__FILE__)).parent.parent
  PUPPET_DIR = BASE_DIR + 'vendor/puppet'
  FACTER_DIR = BASE_DIR + 'vendor/facter'
  AGENT_DIR = BASE_DIR + 'vendor/puppet-agent'
  PE_DIR = BASE_DIR + 'vendor/enterprise-dist'
  PE_SERVER_DIR = BASE_DIR + 'vendor/pe-puppetserver'
  OUTPUT_DIR = BASE_DIR + 'references_output'

  require 'puppet_references/config'
  require 'puppet_references/util'
  require 'puppet_references/repo'
  require 'puppet_references/reference'
  require 'puppet_references/doc_command'
  require 'puppet_references/man_command'
  require 'puppet_references/puppet/puppet_doc'
  require 'puppet_references/puppet/strings'
  require 'puppet_references/puppet/man'
  require 'puppet_references/puppet/type'
  require 'puppet_references/puppet/type_strings'
  require 'puppet_references/puppet/functions'
  require 'puppet_references/facter/core_facts'
  require 'puppet_references/facter/facter_cli'
  require 'puppet_references/version_tables/config'
  require 'puppet_references/version_tables/data/pe'
  require 'puppet_references/version_tables/data/agent'


  def self.build_puppet_references(commit)
    references = [
        PuppetReferences::Puppet::Man,
        PuppetReferences::Puppet::PuppetDoc,
        PuppetReferences::Puppet::Type,
        PuppetReferences::Puppet::TypeStrings,
        PuppetReferences::Puppet::Functions
    ]
    config = PuppetReferences::Config.read
    repo = PuppetReferences::Repo.new('puppet', PUPPET_DIR, nil, config['puppet']['repo'])
    real_commit = repo.checkout(commit)
    repo.update_bundle
    build_from_list_of_classes(references, real_commit)
  end

  def self.is_semantic?(string)
    Gem::Version.correct?(string)
  end

  def self.build_facter_references(commit)
    references = [
        PuppetReferences::Facter::CoreFacts
    ]
    # Adding this workaround so the build doesn't fail for 3.y. Check with Claire to see if
    # we need the CLI docs for 3.y. We can remove this when we stop building 3.y.
    version_4 = Gem::Version.create('4.0.0')
    references << PuppetReferences::Facter::FacterCli if !is_semantic?(commit) || !is_semantic?(commit) && Gem::Version.create(commit) >= version_4
    repo = PuppetReferences::Repo.new('facter', FACTER_DIR)
    real_commit = repo.checkout(commit)
    build_from_list_of_classes(references, real_commit)
  end

  def self.build_from_list_of_classes(reference_classes, real_commit)
    references = reference_classes.map {|r| r.new(real_commit)}
    references.each do |ref|
      ref.build_all
    end

    locations = references.map {|ref|
      "#{ref.class.to_s} -> #{ref.latest}"
    }.join("\n")
    puts 'NOTE: Generated files are in the references_output directory.'
    puts "NOTE: You'll have to move the generated files into place yourself. The 'latest' location for each is:"
    puts locations
  end
end
